$ErrorActionPreference='Stop'
$taskGame=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$taskServer=Join-Path $taskGame 'port\server\local_server.py'
$taskReset=Join-Path $taskGame 'build\reset_outros_perfis.py'
$taskPython=(Get-Command python.exe).Source
& $taskPython $taskReset
if($LASTEXITCODE -ne 0){throw 'Ensaio/backup falhou; servidor não foi interrompido.'}
$taskExisting=@(Get-CimInstance Win32_Process -Filter "name = 'python.exe'" | Where-Object { $_.CommandLine -and $_.CommandLine.Contains($taskServer) })
if($taskExisting.Count -ne 1){throw 'Esperada exatamente uma instância deste servidor; nenhuma alteração aplicada.'}
$taskOldPid=$taskExisting[0].ProcessId
& taskkill.exe /PID $taskOldPid /F
if($LASTEXITCODE -ne 0){throw 'Servidor não foi encerrado; reset não aplicado.'}
Wait-Process -Id $taskOldPid -Timeout 10 -ErrorAction SilentlyContinue
$taskApplied=$false
try {
    & $taskPython $taskReset --apply
    if($LASTEXITCODE -ne 0){throw 'Reset recusado ou falhou; conferir relatório.'}
    $taskApplied=$true
} finally {
    $env:NR_GAME_ROOT=$taskGame
    $env:NR_ACCOUNTS_DIR=Join-Path $taskGame 'port\dados'
    Remove-Item Env:\NR_ENABLE_TUTORIAL -ErrorAction SilentlyContinue
    $env:NR_HOST='0.0.0.0'
    $env:NR_PORT='18080'
    $env:NR_CONTROLE='18081'
    $taskStamp=Get-Date -Format 'yyyyMMdd-HHmmss'
    $taskLog=Join-Path $taskGame ('build\server-initial-tutorial-'+$taskStamp+'.log')
    $taskErrors=Join-Path $taskGame ('build\server-initial-tutorial-'+$taskStamp+'-errors.log')
    $taskProcess=Start-Process -FilePath $taskPython -ArgumentList @('-u',('"'+$taskServer+'"')) -WorkingDirectory $taskGame -WindowStyle Hidden -RedirectStandardOutput $taskLog -RedirectStandardError $taskErrors -PassThru
    $taskReady=$false
    for($taskTry=0;$taskTry -lt 40;$taskTry++){
        if($taskProcess.HasExited){throw ('Servidor encerrou; consultar '+$taskErrors)}
        $taskSocket=New-Object Net.Sockets.TcpClient
        try {$taskSocket.Connect('127.0.0.1',18080);$taskReady=$true} catch {} finally {$taskSocket.Dispose()}
        if($taskReady){break}
        Start-Sleep -Milliseconds 250
    }
    if(-not $taskReady){throw ('Servidor não respondeu; consultar '+$taskErrors)}
}
if(-not $taskApplied){throw 'Servidor restaurado, mas reset não foi aplicado.'}
& $taskPython $taskReset --verify
if($LASTEXITCODE -ne 0){throw 'Servidor no ar; conferir diferença de estado das contas.'}
Write-Output ('SERVER_RESTARTED old_pid='+$taskOldPid+' new_pid='+$taskProcess.Id+' log='+$taskLog)
