@echo off
title Ninja Revolution - diagnostico
rem Abre o jogo e grava todas as mensagens em diagnostico.txt (ao lado deste arquivo).
set "D=%~dp0dados"
if not exist "%D%\build" (echo Coloque este arquivo na pasta NinjaRevolution, ao lado de "Ninja Revolution.exe". & pause & exit /b 1)
rem Atalhos internos: recria se faltarem ou se apontarem para uma pasta antiga (pasta movida).
if not exist "%D%\res\configs\app.config" (rmdir "%D%\res" 2>nul & mklink /J "%D%\res" "%D%\01_conteudo_apk\assets\res" >nul)
if not exist "%D%\src\main.lua" (rmdir "%D%\src" 2>nul & mklink /J "%D%\src" "%D%\01_conteudo_apk\assets\src" >nul)
set "NR_GAME_ROOT=%D%"
set "NR_ENABLE_TUTORIAL=0"
cd /d "%D%"
echo Jogo aberto. As mensagens estao sendo gravadas em diagnostico.txt.
echo Quando a tela travar ou der erro, FECHE O JOGO pelo X e me mande o arquivo diagnostico.txt.
"%D%\build\windows-probe-native\bin\NinjaResourceProbe\Debug\NinjaResourceProbe.exe" > "%~dp0diagnostico.txt" 2>&1
echo.
echo Pronto. Arquivo gravado: %~dp0diagnostico.txt
pause
