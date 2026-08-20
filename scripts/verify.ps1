param(
    [string]$EngineRoot = $env:GEN1RECOMP_ROOT,
    [string]$LuaJit = $env:MODKIT_LUAJIT,
    [string]$Python = $env:TRAINER_CAREER_PYTHON
)

$ErrorActionPreference = 'Stop'
$ModRoot = Split-Path -Parent $PSScriptRoot

if (-not $EngineRoot) {
    throw 'Gen1Recomp path is required. Pass -EngineRoot or set GEN1RECOMP_ROOT.'
}

$Modkit = Join-Path $EngineRoot 'tools\modkit.py'

if (-not $Python) {
    $PythonCommand = Get-Command python -ErrorAction SilentlyContinue
    if (-not $PythonCommand) {
        throw 'Python was not found. Pass -Python or set TRAINER_CAREER_PYTHON.'
    }
    $Python = $PythonCommand.Source
}

if (-not (Test-Path -LiteralPath $Modkit)) {
    throw "Gen1Recomp modkit not found at $Modkit"
}

& $Python $Modkit lint $ModRoot
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if (-not $LuaJit) {
    Write-Error 'LuaJIT is required for loader validation. Set MODKIT_LUAJIT or pass -LuaJit.'
}

$env:MODKIT_LUAJIT = $LuaJit
Push-Location $EngineRoot
try {
    & $Python $Modkit validate $ModRoot
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    & $LuaJit (Join-Path $ModRoot 'tests\trainer_career_smoke_test.lua')
    exit $LASTEXITCODE
}
finally {
    Pop-Location
}
