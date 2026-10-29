@echo off
REM Roda o servidor local e o jogo, gravando os dois consoles em build\probe-writable.
setlocal
cd /d "%~dp0.."
set PW=build\probe-writable
if not exist "%PW%" mkdir "%PW%"

taskkill /IM python.exe /F >nul 2>&1
taskkill /IM NinjaResourceProbe.exe /F >nul 2>&1
ping -n 2 127.0.0.1 >nul

del /q "%PW%\srv-out.log" "%PW%\srv-err.log" "%PW%\run-out.log" "%PW%\run-err.log" 2>nul

start "NR servidor" /min cmd /c "python port\server\local_server.py > %PW%\srv-out.log 2> %PW%\srv-err.log"
ping -n 4 127.0.0.1 >nul

set EXE=build\windows-probe-native\bin\NinjaResourceProbe\Debug\NinjaResourceProbe.exe
start "NR jogo" cmd /c ""%EXE%" > %PW%\run-out.log 2> %PW%\run-err.log"

echo iniciado (servidor + jogo)
