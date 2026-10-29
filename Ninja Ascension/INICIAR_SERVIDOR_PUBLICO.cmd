@echo off
title Servidor Ninja Revolution - MODO PUBLICO (porta 18080)
rem Servidor em janela visivel: mostra os pedidos e erros ao vivo.
rem Fechar esta janela (ou Ctrl+C) desliga o servidor.
set "GAME=%~dp0jogo"
if not exist "%GAME%\res" mklink /J "%GAME%\res" "%GAME%\01_conteudo_apk\assets\res" >nul
if not exist "%GAME%\src" mklink /J "%GAME%\src" "%GAME%\01_conteudo_apk\assets\src" >nul
where python.exe >nul 2>nul || (echo Instale Python 3.11 ou superior, marcando Add Python to PATH. & pause & exit /b 1)
set "NR_GAME_ROOT=%GAME%"
set "NR_ACCOUNTS_DIR=%GAME%\port\dados"
set "NR_ENABLE_TUTORIAL=0"
set "NR_HOST=0.0.0.0"
cd /d "%GAME%"
echo Servidor em modo publico na porta 18080. Feche esta janela para desligar.
echo.
python.exe -u "%GAME%\port\server\local_server.py"
echo.
echo O servidor parou. Veja as mensagens acima.
pause
