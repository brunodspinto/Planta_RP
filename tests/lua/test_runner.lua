local function trim(value)
    return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function readLines(path)
    local lines = {}
    local file, err = io.open(path, "r")
    if not file then
        error("Failed to read list file: " .. path .. " | " .. tostring(err))
    end

    for line in file:lines() do
        local clean = trim(line)
        if clean ~= "" then
            lines[#lines + 1] = clean
        end
    end

    file:close()
    return lines
end

local suiteFiles = readLines("tests/lua/.generated_test_suites.txt")

local passed = 0
local failed = 0

for _, suiteFile in ipairs(suiteFiles) do
    local suite = dofile(suiteFile)

    for _, case in ipairs(suite) do
        local ok, err = pcall(case.test)
        if ok then
            passed = passed + 1
            print("[PASS] " .. case.name)
        else
            failed = failed + 1
            print("[FAIL] " .. case.name)
            print("       " .. tostring(err))
        end
    end
end

print(string.format("\nResult: %d passed, %d failed", passed, failed))

if failed > 0 then
    os.exit(1)
end
