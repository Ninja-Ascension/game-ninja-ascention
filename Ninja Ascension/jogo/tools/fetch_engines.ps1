$ErrorActionPreference='Stop'
$taskRoot=Split-Path $PSScriptRoot -Parent
$engines=@(
  @('axmol','https://github.com/axmolengine/axmol.git','v2.11.5','6c0dce6db4660feafe29dabb1ab3506ee76b0931'),
  @('spine-2.1.25','https://github.com/EsotericSoftware/spine-runtimes.git','2.1.25','142e770e5b4b42395a3a0a68ff3c8a21ba2774eb'),
  @('cocos2d-x-3.5','https://github.com/cocos2d/cocos2d-x.git','cocos2d-x-3.5','f7e11a2467e4508738ad9cf4b3992da05f9d1e7c')
)
foreach($entry in $engines) {
  $target=Join-Path $taskRoot ('build/deps/'+$entry[0])
  if(-not (Test-Path -LiteralPath $target)) {
    git clone --depth 1 --branch $entry[2] $entry[1] $target
    if($LASTEXITCODE -ne 0) {throw 'Engine download failed'}
  }
  $revision=git -C $target rev-parse HEAD
  if($LASTEXITCODE -ne 0 -or $revision -ne $entry[3]) {throw "Engine revision mismatch: $target"}
}
