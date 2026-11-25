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

:: Caminho real de Documents/Downloads (pode estar redirecionado p/ OneDrive ou outro disco)
for /f "usebackq delims=" %%P in (`PowerShell -NoProfile -Command "[Environment]::GetFolderPath('MyDocuments')"`) do if /i "%USERNAME%"=="aluno" set "DOCS=%%P"
for /f "usebackq delims=" %%P in (`PowerShell -NoProfile -Command "(New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path"`) do if /i "%USERNAME%"=="aluno" set "DOWNLOADS=%%P"

:: Programas que costumam travar arquivos nessas pastas
taskkill /f /im java.exe  >nul 2>&1
taskkill /f /im javaw.exe >nul 2>&1
timeout /t 1 >nul

:: Limpa o CONTEUDO (nao apaga a pasta especial). robocopy /MIR de pasta vazia
:: apaga caminhos > 260 chars e arquivos ocultos/sistema/somente-leitura, onde rd falha.
set "VAZIO=%TEMP%\reset_vazio"
mkdir "%VAZIO%" 2>nul

echo Resetando Documents (%DOCS%)...
mkdir "%DOCS%" 2>nul
robocopy "%VAZIO%" "%DOCS%" /MIR /XJ /R:1 /W:1 /NFL /NDL /NJH /NJS /NP >nul

echo Resetando Downloads (%DOWNLOADS%)...
mkdir "%DOWNLOADS%" 2>nul
robocopy "%VAZIO%" "%DOWNLOADS%" /MIR /XJ /R:1 /W:1 /NFL /NDL /NJH /NJS /NP >nul

echo Resetando IdeaProjects...
mkdir "%IDEA%" 2>nul
robocopy "%VAZIO%" "%IDEA%" /MIR /XJ /R:1 /W:1 /NFL /NDL /NJH /NJS /NP >nul

rd "%VAZIO%" 2>nul

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