@echo off
rem Liga o servidor local da Fase 2 (apenas 127.0.0.1:18080).
rem Mantenha esta janela aberta enquanto o jogo estiver rodando.
cd /d "%~dp0..\.."
echo [HOST_SERVER] ligando em 127.0.0.1:18080 ...
python port\server\local_server.py
pause
