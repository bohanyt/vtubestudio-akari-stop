@echo off
setlocal
title Akari Stop - Restore Akari Original
echo.
echo IMPORTANT: Close VTube Studio before continuing.
echo.
pause
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0RESTORE_AKARI_ORIGINAL.ps1"
set "ERR=%ERRORLEVEL%"
echo.
if not "%ERR%"=="0" (
  echo Restore exited with error code %ERR%.
) else (
  echo Done.
)
echo.
pause
exit /b %ERR%
