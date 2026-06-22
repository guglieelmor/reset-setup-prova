@echo off
title Restauracao Ambiente Escolar

set USERDIR=C:\Users\aluno
set DOCS=%USERDIR%\Documents
set DOWNLOADS=%USERDIR%\Downloads
set IDEA=%USERDIR%\IdeaProjects
set USB=%~dp0

echo ==========================================
echo LIMPEZA DO AMBIENTE (VERSAO SEGURA)
echo ==========================================
echo.

:: DOCUMENTS
echo Resetando Documents...
if exist "%DOCS%" rd /s /q "%DOCS%"
mkdir "%DOCS%"

:: DOWNLOADS
echo Resetando Downloads...
if exist "%DOWNLOADS%" rd /s /q "%DOWNLOADS%"
mkdir "%DOWNLOADS%"

:: IDEAPROJECTS
echo Resetando IdeaProjects...
if exist "%IDEA%" rd /s /q "%IDEA%"
mkdir "%IDEA%"

:: VS CODE
echo Removendo VS Code...
if exist "%APPDATA%\Code" rd /s /q "%APPDATA%\Code"
if exist "%USERPROFILE%\.vscode" rd /s /q "%USERPROFILE%\.vscode"
if exist "%USERPROFILE%\.vscode-insiders" rd /s /q "%USERPROFILE%\.vscode-insiders"

:: LIXEIRA
echo Esvaziando Lixeira...
PowerShell -NoProfile -Command "Clear-RecycleBin -Force" >nul 2>&1

echo.
echo ==========================================
echo COPIA DO PENDRIVE
echo ==========================================
echo.

set /p ITEM=Digite o nome da pasta ou arquivo do pendrive: 

if not exist "%USB%%ITEM%" (
    echo Item nao encontrado.
    pause
    exit /b
)

if exist "%USB%%ITEM%\*" (
    robocopy "%USB%%ITEM%" "%DOCS%\%ITEM%" /E
) else (
    copy "%USB%%ITEM%" "%DOCS%"
)

echo.
echo CONCLUIDO
pause