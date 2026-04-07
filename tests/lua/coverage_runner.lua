local suiteFiles = {
    "tests/lua/unit/qb-weapons/aiming_logic_spec.lua",
}

local passed = 0
local failed = 0

local coverageEnabled = false
do
    if os.getenv("ENABLE_LUACOV") == "1" then
        local ok = pcall(require, "luacov")
        if ok then
            coverageEnabled = true
            print("[INFO] LuaCov coverage enabled")
        else
            print("[INFO] LuaCov requested but not available. Running without coverage.")
        end
    end
end

local function flushCoverage()
    if not coverageEnabled then
        return
    end

    local ok, err = pcall(function()
        require("luacov.runner").shutdown()
    end)

    if not ok then
        print("[WARN] Failed to finalize LuaCov report: " .. tostring(err))
    end
end

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

print(string.format("\nCoverage suites result: %d passed, %d failed", passed, failed))
flushCoverage()

if failed > 0 then
    os.exit(1)
end
