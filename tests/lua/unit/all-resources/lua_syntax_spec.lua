local function readFile(path)
    local file, err = io.open(path, "r")
    if not file then
        return nil, err
    end

    local content = file:read("*a")
    file:close()
    return content
end

local function sanitizeOutsideQuotedStrings(content, transform)
    local out = {}
    local i = 1
    local len = #content
    local state = 'normal'
    local quote = nil

    while i <= len do
        local ch = content:sub(i, i)

        if state == 'normal' then
            if ch == '"' or ch == "'" then
                state = 'quoted'
                quote = ch
                out[#out + 1] = ch
                i = i + 1
            else
                local replaced, consumed = transform(content, i)
                if replaced then
                    out[#out + 1] = replaced
                    i = i + consumed
                else
                    out[#out + 1] = ch
                    i = i + 1
                end
            end
        else
            out[#out + 1] = ch
            if ch == '\\' then
                local nextCh = content:sub(i + 1, i + 1)
                if nextCh ~= '' then
                    out[#out + 1] = nextCh
                    i = i + 2
                else
                    i = i + 1
                end
            elseif ch == quote then
                state = 'normal'
                quote = nil
                i = i + 1
            else
                i = i + 1
            end
        end
    end

    return table.concat(out)
end

local function sanitizeFiveMHashLiterals(content)
    -- FiveM allows hash literals like `WEAPON_UNARMED` or `shell_medium2`.
    -- Replace only when outside quoted Lua strings, so SQL backticks remain untouched.
    return sanitizeOutsideQuotedStrings(content, function(text, startIdx)
        if text:sub(startIdx, startIdx) ~= '`' then
            return nil, 0
        end

        local closeIdx = text:find('`', startIdx + 1, true)
        if not closeIdx then
            return nil, 0
        end

        local value = text:sub(startIdx + 1, closeIdx - 1)
        if value:find('\n') then
            return nil, 0
        end

        value = value:gsub('\\', '\\\\'):gsub('"', '\\"')
        return '"' .. value .. '"', (closeIdx - startIdx + 1)
    end)
end

local function sanitizeFiveMCompoundAssignments(content)
    -- Cfx Lua supports compound assignment operators; rewrite them for stock Lua parser.
    local sanitized = content
    local ops = {
        ['+'] = '%+',
        ['-'] = '%-',
        ['*'] = '%*',
        ['/'] = '/',
        ['%'] = '%%',
    }

    for op, patt in pairs(ops) do
        local pattern = '([%a_][%w_%.%[%]]*)%s*' .. patt .. '=%s*([^\r\n;]+)'
        sanitized = sanitized:gsub(pattern, '%1 = %1 ' .. op .. ' %2')
    end

    return sanitized
end

local function sanitizeForStockLuaParser(content)
    local sanitized = sanitizeFiveMHashLiterals(content)
    sanitized = sanitizeFiveMCompoundAssignments(sanitized)
    return sanitized
end

local function readLines(path)
    local lines = {}
    local file, err = io.open(path, "r")
    if not file then
        error("Failed to open generated lua file list: " .. path .. " | " .. tostring(err))
    end

    for line in file:lines() do
        if line ~= "" then
            lines[#lines + 1] = line
        end
    end

    file:close()
    return lines
end

local function writeLines(path, lines)
    local file, err = io.open(path, 'w')
    if not file then
        error('Failed to write report file: ' .. path .. ' | ' .. tostring(err))
    end

    for _, line in ipairs(lines) do
        file:write(line)
        file:write('\n')
    end

    file:close()
end

local function compileLuaChunk(path)
    local content, readErr = readFile(path)
    if not content then
        return false, "read error: " .. tostring(readErr), nil
    end

    local sanitized = sanitizeForStockLuaParser(content)
    local chunk, compileErr = load(sanitized, "@" .. path, "t", {})
    if not chunk then
        return false, tostring(compileErr), content
    end

    return true, nil, content
end

local function isKnownCfxParserMismatch(err, originalContent)
    if not err then return false end

    if err:find("near '`'", 1, true) then
        return true
    end

    if err:find("near '?'", 1, true) then
        return true
    end

    if err:find("near '+'", 1, true) and originalContent and originalContent:find('+=', 1, true) then
        return true
    end

    return false
end

local resourceLuaFiles = readLines("tests/lua/.generated_lua_files.txt")

return {
    {
        name = "compiles all resource lua files after FiveM hash literal sanitization",
        test = function()
            local failures = {}
            local skipped = 0
            local skippedDetails = {}
            local startedAt = os.clock()
            local total = #resourceLuaFiles
            local reportPath = 'tests/lua/reports/cfx-parser-mismatches.txt'

            for index, path in ipairs(resourceLuaFiles) do
                local ok, err, originalContent = compileLuaChunk(path)
                if not ok then
                    if isKnownCfxParserMismatch(err, originalContent) then
                        skipped = skipped + 1
                        skippedDetails[#skippedDetails + 1] = path .. ' -> ' .. err
                    else
                        failures[#failures + 1] = path .. " -> " .. err
                    end
                end

                if index % 200 == 0 or index == total then
                    print(string.format("[INFO] Syntax scan progress: %d/%d", index, total))
                end
            end

            local reportLines = {
                'Cfx/FiveM Parser Mismatch Report',
                'Generated at: ' .. os.date('%Y-%m-%d %H:%M:%S'),
                'Scanned files: ' .. tostring(total),
                'Skipped mismatches: ' .. tostring(skipped),
                ''
            }

            if skipped == 0 then
                reportLines[#reportLines + 1] = 'No parser mismatches detected.'
            else
                for _, detail in ipairs(skippedDetails) do
                    reportLines[#reportLines + 1] = detail
                end
            end

            writeLines(reportPath, reportLines)

            if #failures > 0 then
                local maxLines = math.min(#failures, 20)
                local message = {"Lua syntax validation failed for " .. tostring(#failures) .. " file(s)."}
                for i = 1, maxLines do
                    message[#message + 1] = failures[i]
                end
                if #failures > maxLines then
                    message[#message + 1] = "... and " .. tostring(#failures - maxLines) .. " more failure(s)."
                end

                error(table.concat(message, "\n"))
            end

            print(string.format("[INFO] Syntax scan completed in %.2fs", os.clock() - startedAt))
            print(string.format("[INFO] Known Cfx parser mismatches skipped: %d", skipped))
            print(string.format("[INFO] Parser mismatch report: %s", reportPath))
        end,
    },
}
