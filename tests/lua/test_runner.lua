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
local suiteExcludePattern = os.getenv("TEST_SUITE_EXCLUDE_PATTERN")

if suiteExcludePattern and suiteExcludePattern ~= "" then
    local filtered = {}
    for _, suiteFile in ipairs(suiteFiles) do
        if not string.find(suiteFile, suiteExcludePattern) then
            filtered[#filtered + 1] = suiteFile
        end
    end
    suiteFiles = filtered
end

local coverageEnabled = false
do
    if os.getenv("ENABLE_LUACOV") == "1" then
        local ok = pcall(require, "luacov")
        if ok then
            coverageEnabled = true
            print("[INFO] LuaCov coverage enabled")
        else
            print("[INFO] LuaCov requested but not available. Running tests without coverage.")
        end
    else
        print("[INFO] Coverage disabled for this test pass.")
    end
end

local function flushCoverage()
    if not coverageEnabled then
        return
    end

    -- Force report flush before process exit.
    local ok, err = pcall(function()
        require("luacov.runner").shutdown()
    end)

    if not ok then
        print("[WARN] Failed to finalize LuaCov report: " .. tostring(err))
    end
end

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

flushCoverage()

if failed > 0 then
    os.exit(1)
end
