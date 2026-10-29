param([switch]$ConfigureOnly, [string]$SourceRoot, [string]$Generator)
$ErrorActionPreference='Stop'
$taskRoot=Split-Path $PSScriptRoot -Parent
if(-not $SourceRoot) { $SourceRoot=$taskRoot }
if($SourceRoot -match '[\[\]]') { throw 'CMake globs cannot safely handle brackets in this path. Use subst N: "E:\[code]\nk", then run this script with -SourceRoot N:/.' }
$cmakeCommand=Get-Command cmake -ErrorAction SilentlyContinue
if(-not $cmakeCommand) { throw 'Missing CMake >=3.22. Install VS2022 Desktop development with C++, Windows SDK and CMake tools; see port/docs/BUILD_WINDOWS.md.' }
$axPath=Join-Path $SourceRoot 'build/deps/axmol'
if(-not (Test-Path -LiteralPath $axPath)) { throw 'Missing pinned Axmol checkout. Run tools/fetch_engines.ps1 first.' }
if(-not $Generator) {
  $vswhere=Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
  if(-not (Test-Path -LiteralPath $vswhere)) { throw 'Visual Studio Installer/vswhere not found.' }
  $version=& $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationVersion
  if($version -match '^18\.') { $Generator='Visual Studio 18 2026' }
  elseif($version -match '^17\.') { $Generator='Visual Studio 17 2022' }
  else { throw "No supported Visual Studio C++ installation found: $version" }
}
$buildPath=Join-Path $SourceRoot 'build/windows-probe-native'
& $cmakeCommand.Source -S (Join-Path $SourceRoot 'port') -B $buildPath -G $Generator -A x64 "-DAX_ROOT=$axPath" "-DNR_REFERENCE_ROOT=$($taskRoot.Replace('\','/'))"
if($LASTEXITCODE -ne 0) { throw 'CMake configure failed; native probe not built.' }
if(-not $ConfigureOnly) {
  & $cmakeCommand.Source --build $buildPath --config Debug --target NinjaResourceProbe --parallel 4
  if($LASTEXITCODE -ne 0) { throw 'Native probe build failed.' }
}
