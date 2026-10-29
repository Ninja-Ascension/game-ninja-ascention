$ErrorActionPreference='Stop'
$game=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$server=Join-Path $game 'port\server\local_server.py'
$record=Join-Path $game 'build\quick-upgrades-backup.json'
if(-not (Test-Path -LiteralPath $record)){throw 'Backup consistente obrigatório antes do reinício.'}
$python=(Get-Command python.exe).Source
& $python (Join-Path $PSScriptRoot 'backup_quick_upgrades.py') --verify
if($LASTEXITCODE -ne 0){throw 'Verificação das contas falhou; servidor mantido.'}
$existing=@(Get-CimInstance Win32_Process -Filter "name = 'python.exe'" | Where-Object { $_.CommandLine -and $_.CommandLine.Contains($server) })
if($existing.Count -lt 1){throw 'Nenhuma instância deste servidor encontrada.'}
# Exact project path above restricts this to the game's own processes. Multiple
# instances can coexist on Windows; replace all of them with one listener.
$previous=@($existing | ForEach-Object { $_.ProcessId })
foreach($serverProcessId in $previous){
    & taskkill.exe /PID $serverProcessId /F
    if($LASTEXITCODE -ne 0 -and (Get-Process -Id $serverProcessId -ErrorAction SilentlyContinue)){
        throw ('Falha ao encerrar servidor '+$serverProcessId)
    }
}
Wait-Process -Id $previous -Timeout 15 -ErrorAction SilentlyContinue
$env:NR_GAME_ROOT=$game
$env:NR_ACCOUNTS_DIR=Join-Path $game 'port\dados'
$env:NR_ENABLE_TUTORIAL='0'
$env:NR_HOST='0.0.0.0'
$env:NR_PORT='18080'
$env:NR_CONTROLE='18081'
$stamp=Get-Date -Format 'yyyyMMdd-HHmmss'
$log=Join-Path $game ('build\server-quick-upgrades-'+$stamp+'.log')
$errors=Join-Path $game ('build\server-quick-upgrades-'+$stamp+'-errors.log')
$process=Start-Process -FilePath $python -ArgumentList @('-u',('"'+$server+'"')) -WorkingDirectory $game -WindowStyle Hidden -RedirectStandardOutput $log -RedirectStandardError $errors -PassThru
$ready=$false
for($i=0;$i -lt 40;$i++){
    if($process.HasExited){throw ('Servidor encerrou: '+$errors)}
    $socket=New-Object Net.Sockets.TcpClient
    try{$socket.Connect('127.0.0.1',18080);$ready=$true}catch{}finally{$socket.Dispose()}
    if($ready){break}
    Start-Sleep -Milliseconds 250
}
if(-not $ready){throw ('Servidor não respondeu: '+$errors)}
& $python (Join-Path $PSScriptRoot 'backup_quick_upgrades.py') --verify
if($LASTEXITCODE -ne 0){throw 'Servidor reiniciado; revisar diferença de estado das contas.'}
Write-Output ('SERVER_RESTARTED old_pid='+($previous -join ',')+' new_pid='+$process.Id+' public_port=18080 log='+$log)
