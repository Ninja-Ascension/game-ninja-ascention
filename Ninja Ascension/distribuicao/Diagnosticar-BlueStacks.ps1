param([string]$Serial='127.0.0.1:5555',[switch]$Reiniciar,[ValidateRange(0,120)][int]$AguardarSegundos=45)
$ErrorActionPreference='Stop'
$adbCandidates=@(
    (Join-Path $env:ProgramFiles 'BlueStacks_nxt\HD-Adb.exe'),
    (Join-Path $env:ProgramFiles 'BlueStacks\HD-Adb.exe'),
    (Join-Path ${env:ProgramFiles(x86)} 'BlueStacks_nxt\HD-Adb.exe')
)
$adb=$adbCandidates | Where-Object {Test-Path -LiteralPath $_} | Select-Object -First 1
if(-not $adb){throw 'HD-Adb.exe nao encontrado. Execute no PC com BlueStacks.'}
& $adb start-server
& $adb connect $Serial
$state=(& $adb -s $Serial get-state 2>&1 | Out-String).Trim()
if($LASTEXITCODE -ne 0 -or $state -ne 'device'){
    & $adb devices -l
    throw "Nao foi possivel acessar $Serial. Confira o endereco ADB exibido pelo BlueStacks e use -Serial ENDERECO:PORTA."
}
$package='com.ryzengames.ninjarevolution'
$report=Join-Path $PSScriptRoot ('NinjaAscension-diagnostico-'+(Get-Date -Format 'yyyyMMdd-HHmmss')+'.txt')
'NinjaAscension / BlueStacks startup diagnostic' | Set-Content -LiteralPath $report -Encoding utf8
& $adb -s $serial shell getprop ro.build.version.release | Add-Content -LiteralPath $report
& $adb -s $serial shell getprop ro.product.cpu.abilist | Add-Content -LiteralPath $report
& $adb -s $serial shell dumpsys package $package | Select-String 'versionCode=|versionName=|primaryCpuAbi=' | Add-Content -LiteralPath $report
$apkPath=(& $adb -s $serial shell pm path $package | Select-Object -First 1) -replace '^package:',''
if($apkPath){& $adb -s $serial shell sha256sum ($apkPath.Trim()) | Add-Content -LiteralPath $report}
# Capture stdout, stderr and exit status without hiding native failures.
function Capture-Adb([string]$Title,[string[]]$Arguments){
    Add-Content -LiteralPath $report -Value ("`r`n=== "+$Title+" ===")
    $ErrorActionPreference='Continue'
    $output=& $adb -s $serial @Arguments 2>&1
    $status=$LASTEXITCODE
    $output | ForEach-Object {"$_"} | Add-Content -LiteralPath $report -Encoding utf8
    Add-Content -LiteralPath $report -Value ("ADB_EXIT="+$status) -Encoding utf8
}
if($Reiniciar){
    Capture-Adb 'STOP GAME' @('shell','am','force-stop',$package)
    Capture-Adb 'START GAME' @('shell','monkey','-p',$package,'-c','android.intent.category.LAUNCHER','1')
    Read-Host 'Entre no jogo e aguarde o travamento. Depois pressione Enter aqui para coletar'
}else{
    Write-Host 'Coletando o estado atual sem fechar nem reiniciar o jogo.'
}
Write-Host "Mantenha o jogo aberto na tela travada. A coleta comeca em $AguardarSegundos segundos."
if($AguardarSegundos -gt 0){Start-Sleep -Seconds $AguardarSegundos}
Capture-Adb 'DEVICE TIME AT COLLECTION' @('shell','date')
Capture-Adb 'GAME PID' @('shell','pidof',$package)
# No date/locale or keyword filter: collect native and Java failures too.
Capture-Adb 'LOGCAT ALL BUFFERS' @('logcat','-b','all','-d','-v','threadtime','-t','12000')
Capture-Adb 'ACTIVITY STATE' @('shell','dumpsys','activity','activities')
Capture-Adb 'GRAPHICS STATE' @('shell','dumpsys','gfxinfo',$package)
Capture-Adb 'LUA STARTUP FILE (if debuggable)' @('shell','run-as',$package,'cat','files/nr-mobile-startup.log')
Write-Host "Relatorio salvo: $report"
