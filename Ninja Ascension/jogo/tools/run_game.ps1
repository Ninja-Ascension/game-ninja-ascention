# run_game.ps1 — SINGLE COMMAND: build + launch the ORIGINAL game chain.
#
#   powershell -ExecutionPolicy Bypass -File tools\run_game.ps1          (build + run)
#   powershell -ExecutionPolicy Bypass -File tools\run_game.ps1 -NoBuild (run only)
#
# What it does:
#   1. (unless -NoBuild) builds NinjaResourceProbe with the pinned deps;
#   2. recreates the res/src junctions next to the exe if a reboot removed them;
#   3. starts the exe with NR_PROBE_AUTO_REAL_CHAIN=1 — the probe boots the
#      ORIGINAL chain (boot_map -> fwin scene -> logo -> login) automatically;
#      no test panel is created in this mode.
#
# Honest scope: this is the REAL recovered game content running under Axmol.
# Offline boundaries (server connectivity, missing recovered art such as some
# login images, native crypto bindings) fail through the original error paths
# or loud, documented adapters — the game does not pretend online play.
param([switch]$NoBuild)
$ErrorActionPreference='Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $root

if(-not $NoBuild){
    cmake --build build\windows-probe-native --config Debug --target NinjaResourceProbe
    if($LASTEXITCODE -ne 0){ throw "build failed (exit $LASTEXITCODE)" }
}

$exe = Join-Path $root 'build\windows-probe-native\bin\NinjaResourceProbe\Debug\NinjaResourceProbe.exe'
if(-not (Test-Path -LiteralPath $exe)){ throw "exe missing: $exe" }
$bin = Split-Path -Parent $exe

foreach($j in @('res','src')){
    $dest=Join-Path $bin $j
    $target=Join-Path $root ('01_conteudo_apk\assets\'+$j)
    if(-not (Test-Path -LiteralPath $dest)){
        Write-Host "recreating junction $dest -> $target"
        cmd /c mklink /J "`"$dest`"" "`"$target`"" | Out-Null
    }
}

$env:NR_PROBE_AUTO_REAL_CHAIN='1'
$env:NR_PROBE_TEST_MODE=$null
Write-Host "launching game host: $exe"
& $exe
