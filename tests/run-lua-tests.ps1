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

New-Item -ItemType Directory -Path "tests/lua" -Force | Out-Null
New-Item -ItemType Directory -Path "tests/lua/reports" -Force | Out-Null

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
exit $LASTEXITCODE
