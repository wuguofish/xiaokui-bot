@echo off
setlocal EnableExtensions
chcp 65001 >NUL
title Xiaokui Codex App Server
cd /d "%~dp0"

set "CODEX_CMD="
set "CODEX_PATH_VALUE="
set "CODEX_WS_URL_VALUE="

call :load_env

if "%CODEX_PATH%"=="" if not "%CODEX_PATH_VALUE%"=="" set "CODEX_PATH=%CODEX_PATH_VALUE%"
if "%CODEX_WS_URL%"=="" if not "%CODEX_WS_URL_VALUE%"=="" set "CODEX_WS_URL=%CODEX_WS_URL_VALUE%"
if "%CODEX_WS_URL%"=="" set "CODEX_WS_URL=ws://127.0.0.1:45888"

call :find_codex
if errorlevel 1 (
    echo [error] codex CLI was not found.
    pause
    exit /b 1
)

echo [xiaokui] starting codex app-server on %CODEX_WS_URL%
call "%CODEX_CMD%" app-server --listen "%CODEX_WS_URL%"
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" (
    echo [xiaokui] app-server exited with code %EXIT_CODE%
    pause
)

exit /b %EXIT_CODE%

:load_env
if not exist ".env.xiaokui" exit /b 0

for /f "usebackq tokens=1,* delims==" %%A in (".env.xiaokui") do (
    if /I "%%A"=="CODEX_PATH" set "CODEX_PATH_VALUE=%%B"
    if /I "%%A"=="CODEX_WS_URL" set "CODEX_WS_URL_VALUE=%%B"
)

exit /b 0

:find_codex
if not "%CODEX_PATH%"=="" (
    if exist "%CODEX_PATH%" (
        set "CODEX_CMD=%CODEX_PATH%"
        exit /b 0
    )
    for /f "delims=" %%I in ('where %CODEX_PATH% 2^>NUL') do if not defined CODEX_CMD set "CODEX_CMD=%%I"
    if defined CODEX_CMD exit /b 0
)

for /f "delims=" %%I in ('where codex.cmd 2^>NUL') do if not defined CODEX_CMD set "CODEX_CMD=%%I"
for /f "delims=" %%I in ('where codex.exe 2^>NUL') do if not defined CODEX_CMD set "CODEX_CMD=%%I"
for /f "delims=" %%I in ('where codex 2^>NUL') do if not defined CODEX_CMD set "CODEX_CMD=%%I"

if defined CODEX_CMD (
    exit /b 0
)

exit /b 1
