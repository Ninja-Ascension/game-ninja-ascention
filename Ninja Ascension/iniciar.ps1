param([switch]$SomenteServidor,[switch]$Publico)
$ErrorActionPreference='Stop'
$game=Join-Path $PSScriptRoot 'jogo'
Set-Location -LiteralPath $game
foreach($name in @('res','src')) {
    $path=Join-Path $game $name
    $target=Join-Path $game ('01_conteudo_apk\assets\'+$name)
    if(-not (Test-Path -LiteralPath $path)) { New-Item -ItemType Junction -Path $path -Target $target | Out-Null }
}
$python=Get-Command python.exe -ErrorAction SilentlyContinue
if(-not $python){throw 'Instale Python 3.11 ou superior, marcando Add Python to PATH.'}
$env:NR_GAME_ROOT=$game
$env:NR_ACCOUNTS_DIR=Join-Path $game 'port\dados'
$env:NR_ENABLE_TUTORIAL='0'
# Publico: escuta em todas as interfaces e exige a chave de sessao em cada pedido.
# A porta 18080 ainda precisa ser liberada no firewall pelo administrador.
if($Publico){$env:NR_HOST='0.0.0.0'}else{Remove-Item Env:\NR_HOST -ErrorAction SilentlyContinue}
Get-ChildItem Env: | Where-Object Name -Like 'NR_PROBE_*' | ForEach-Object { Remove-Item -LiteralPath ('Env:\'+$_.Name) }
$logs=Join-Path $PSScriptRoot 'logs';New-Item -ItemType Directory -Path $logs -Force | Out-Null
$listening=Get-NetTCPConnection -LocalPort 18080 -State Listen -ErrorAction SilentlyContinue
if($listening){throw 'A porta 18080 já está em uso. Feche o servidor anterior antes de iniciar este pacote.'}
$server=Join-Path $game 'port\server\local_server.py'
$proc=Start-Process -FilePath $python.Source -ArgumentList @('-u',('"'+$server+'"')) -WorkingDirectory $game -WindowStyle Hidden -RedirectStandardOutput (Join-Path $logs 'servidor.log') -RedirectStandardError (Join-Path $logs 'servidor-erros.log') -PassThru
$ready=$false
for($i=0;$i -lt 40;$i++) {
    if($proc.HasExited){throw 'O servidor encerrou. Confira logs\servidor-erros.log.'}
    $socket=New-Object Net.Sockets.TcpClient
    try { $socket.Connect('127.0.0.1',18080);$ready=$true } catch {} finally { $socket.Dispose() }
    if($ready){break};Start-Sleep -Milliseconds 250
}
if(-not $ready){throw 'Servidor não iniciou em 10 segundos. Confira os logs.'}
Write-Host "Servidor iniciado. PID: $($proc.Id)"
if($Publico){Write-Host "Modo publico: porta 18080 em todas as interfaces (sessao obrigatoria)."}
if(-not $SomenteServidor) {
    $env:NR_PROBE_AUTO_REAL_CHAIN='1'
    $exe=Join-Path $game 'build\windows-probe-native\bin\NinjaResourceProbe\Debug\NinjaResourceProbe.exe'
    # Pasta de trabalho = raiz do jogo: o Axmol resolve "res"/"src" a partir dela.
    Start-Process -FilePath $exe -WorkingDirectory $game
}
