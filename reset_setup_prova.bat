@echo off
title Restauracao Ambiente Escolar

set USERDIR=C:\Users\aluno
set DOCS=%USERDIR%\Documents
set DOWNLOADS=%USERDIR%\Downloads
set IDEA=%USERDIR%\IdeaProjects
set APPDATA_ALUNO=%USERDIR%\AppData\Roaming
set LOCALAPPDATA_ALUNO=%USERDIR%\AppData\Local
set USB=%~dp0

echo ==========================================
echo LIMPEZA DO AMBIENTE (VERSAO SEGURA)
echo ==========================================
echo.

:: FECHAR IDES ABERTAS
echo Fechando IDEs...
taskkill /f /im idea64.exe >nul 2>&1
taskkill /f /im idea.exe   >nul 2>&1
taskkill /f /im Code.exe   >nul 2>&1
timeout /t 2 >nul

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

:: INTELLIJ - REMOVER PLUGINS/EXTENSOES
echo Removendo plugins do IntelliJ...

:: Versoes 2020.1+ (config e cache de plugins)
for /d %%D in ("%APPDATA_ALUNO%\JetBrains\*") do (
    if exist "%%D\plugins" rd /s /q "%%D\plugins"
)
for /d %%D in ("%LOCALAPPDATA_ALUNO%\JetBrains\*") do (
    if exist "%%D\plugins" rd /s /q "%%D\plugins"
)

:: Versoes anteriores a 2020.1 (Ultimate e Community)
for /d %%D in ("%USERDIR%\.IntelliJIdea*") do (
    if exist "%%D\config\plugins" rd /s /q "%%D\config\plugins"
)
for /d %%D in ("%USERDIR%\.IdeaIC*") do (
    if exist "%%D\config\plugins" rd /s /q "%%D\config\plugins"
)

:: VS CODE
echo Removendo VS Code...
if exist "%APPDATA_ALUNO%\Code" rd /s /q "%APPDATA_ALUNO%\Code"
if exist "%USERDIR%\.vscode" rd /s /q "%USERDIR%\.vscode"
if exist "%USERDIR%\.vscode-insiders" rd /s /q "%USERDIR%\.vscode-insiders"

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