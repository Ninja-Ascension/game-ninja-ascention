@echo off
cd /d "%~dp0jogo\port\server"
start "" http://127.0.0.1:18090
python painel_gm.py
