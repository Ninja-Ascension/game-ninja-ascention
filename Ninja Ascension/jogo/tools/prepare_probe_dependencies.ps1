$ErrorActionPreference='Stop'
$taskRoot=Split-Path $PSScriptRoot -Parent
$archive=Join-Path $taskRoot 'build/downloads/axslcc-1.14.0-win64.zip'
$destination=Join-Path $taskRoot 'build/deps/axmol/tools/external/axslcc'
$expected='5EA1AE25517A14A81B578836563837FDDCB3FECA005581761446F3E75986E828'
New-Item -ItemType Directory -Force -Path (Split-Path $archive -Parent) | Out-Null
if(-not (Test-Path -LiteralPath $archive)) {
  Invoke-WebRequest -Uri 'https://github.com/axmolengine/axslcc/releases/download/v1.14.0/axslcc-1.14.0-win64.zip' -OutFile $archive
}
if((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash -ne $expected) {throw 'axslcc archive checksum mismatch'}
Expand-Archive -LiteralPath $archive -DestinationPath $destination -Force
if(-not (Test-Path -LiteralPath (Join-Path $destination 'axslcc.exe'))) {throw 'axslcc executable missing after extraction'}
Write-Output 'Verified axslcc 1.14.0 ready. CMake will fetch remaining pinned engine dependencies.'
