@echo off
setlocal
title Akari Stop - Freeze Akari Watermark Movement
echo.
echo IMPORTANT: Close VTube Studio before continuing.
echo.
pause
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0PATCH_AKARI_FREEZE.ps1"
set "ERR=%ERRORLEVEL%"
echo.
if not "%ERR%"=="0" (
  echo Patch exited with error code %ERR%.
) else (
  echo Done.
)
echo.
pause
exit /b %ERR%
