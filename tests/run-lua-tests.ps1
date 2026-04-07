$lua = Get-Command lua -ErrorAction SilentlyContinue
if (-not $lua) {
    $luaFallback = Join-Path $env:LOCALAPPDATA "Programs\Lua\bin\lua.exe"
    if (Test-Path -LiteralPath $luaFallback) {
        $lua = Get-Item -LiteralPath $luaFallback
    }
}

if (-not $lua) {
    Write-Error "Lua interpreter not found in PATH. Install Lua 5.4+ and run again."
    exit 1
}

$luaPath = $lua.Source
if (-not $luaPath -and $lua.PSObject.Properties['FullName']) {
    $luaPath = $lua.FullName
}

if (-not $luaPath) {
    Write-Error "Lua executable path could not be resolved."
    exit 1
}

$luarocks = Get-Command luarocks -ErrorAction SilentlyContinue
if ($luarocks) {
    $luarocksEnv = & $luarocks.Source path 2>$null
    foreach ($line in $luarocksEnv) {
        if ($line -like "SET LUA_PATH=*") {
            $env:LUA_PATH = $line.Substring("SET LUA_PATH=".Length)
        } elseif ($line -like "SET LUA_CPATH=*") {
            $env:LUA_CPATH = $line.Substring("SET LUA_CPATH=".Length)
        } elseif ($line -like "SET PATH=*") {
            $env:PATH = $line.Substring("SET PATH=".Length)
        }
    }
}

New-Item -ItemType Directory -Path "tests/lua" -Force | Out-Null
New-Item -ItemType Directory -Path "tests/lua/reports" -Force | Out-Null

$coverageStats = Join-Path $PWD.Path "tests/lua/reports/luacov.stats.out"
$coverageReport = Join-Path $PWD.Path "tests/lua/reports/luacov.report.out"
if (Test-Path -LiteralPath $coverageStats) {
    Remove-Item -LiteralPath $coverageStats -Force
}
if (Test-Path -LiteralPath $coverageReport) {
    Remove-Item -LiteralPath $coverageReport -Force
}

$resourceLuaFiles = Get-ChildItem -LiteralPath ".\resources" -Recurse -File -Filter "*.lua" |
    ForEach-Object {
        $_.FullName.Substring($PWD.Path.Length + 1).Replace('\\', '/')
    } |
    Sort-Object

$suiteFiles = Get-ChildItem -LiteralPath ".\tests\lua\unit" -Recurse -File -Filter "*_spec.lua" |
    ForEach-Object {
        $_.FullName.Substring($PWD.Path.Length + 1).Replace('\\', '/')
    } |
    Sort-Object

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines((Join-Path $PWD.Path "tests/lua/.generated_lua_files.txt"), $resourceLuaFiles, $utf8NoBom)
[System.IO.File]::WriteAllLines((Join-Path $PWD.Path "tests/lua/.generated_test_suites.txt"), $suiteFiles, $utf8NoBom)

& $luaPath "tests/lua/test_runner.lua"
$fullTestExit = $LASTEXITCODE

if ($fullTestExit -ne 0) {
    exit $fullTestExit
}

$env:ENABLE_LUACOV = "1"
& $luaPath "tests/lua/coverage_runner.lua"
$coverageTestExit = $LASTEXITCODE
Remove-Item Env:ENABLE_LUACOV -ErrorAction SilentlyContinue

$exitCode = $coverageTestExit

if (Test-Path -LiteralPath $coverageStats) {
    & $luaPath -e "require('luacov.runner').load_config('.luacov'); require('luacov.reporter').report()" | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Coverage report generation failed."
        if ($exitCode -eq 0) {
            $exitCode = $LASTEXITCODE
        }
    }
}

if (Test-Path -LiteralPath $coverageReport) {
    Write-Host "Coverage report generated at: tests/lua/reports/luacov.report.out"

    $coverageMatch = Select-String -LiteralPath $coverageReport -Pattern "^Total\s+\d+\s+\d+\s+([0-9]+\.[0-9]+)%$" -AllMatches
    if ($coverageMatch -and $coverageMatch.Matches.Count -gt 0) {
        $coverageValue = [double]$coverageMatch.Matches[0].Groups[1].Value
        [double]$coverageMin = 80
        if ($env:LUA_COVERAGE_MIN) {
            [void][double]::TryParse($env:LUA_COVERAGE_MIN, [ref]$coverageMin)
        }

        Write-Host ("Coverage total: {0:N2}% (minimum: {1:N2}%)" -f $coverageValue, $coverageMin)
        if ($coverageValue -lt $coverageMin -and $exitCode -eq 0) {
            Write-Host "Coverage gate failed."
            $exitCode = 2
        }
    }
} else {
    Write-Host "Coverage report not generated (install LuaCov to enable)."
}
exit $exitCode
