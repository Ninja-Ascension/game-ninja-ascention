@echo off
rem Fase 2 — joga local: sobe o servidor (se preciso) e abre o jogo.
rem Duplo-clique nele; NAO precisa mexer em mais nada.
cd /d "%~dp0..\.."
netstat -ano | find "LISTENING" | find ":18080" >nul
if errorlevel 1 (
  echo [HOST_SERVER] servidor offline - ligando em uma janela propria...
  start "NR servidor local" /min python port\server\local_server.py
  timeout /t 2 /nobreak >nul
) else (
  echo [HOST_SERVER] servidor ja esta no ar em 127.0.0.1:18080.
)
echo [HOST_SERVER] abrindo o jogo...
start "" "build\windows-probe-native\bin\NinjaResourceProbe\Debug\NinjaResourceProbe.exe"
echo [HOST_SERVER] pronto. Clique em GAME START no jogo.
