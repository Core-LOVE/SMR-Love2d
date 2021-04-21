@echo off
set PGE_WIN32ZIP=https://builds.wohlsoft.ru/win32/bin-w32/_packed/pge-project-master-win32.zip

echo ================================================
echo       Welcome to PGE Project update tool!
echo ================================================
echo     Please, close Editor, Engine, Maintainer,
echo       and Calibrator until continue update
echo ================================================
echo          To quit from this utility just
echo       close [x] this window or hit Ctrl+C
echo.
echo Overwise, to begin update process, just
pause

echo.
echo * Preparing...
taskkill /t /f /im pge_editor.exe > NUL 2>&1
taskkill /t /f /im pge_engine.exe > NUL 2>&1
taskkill /t /f /im pge_musplay.exe > NUL 2>&1
taskkill /t /f /im pge_calibrator.exe > NUL 2>&1
taskkill /t /f /im pge_maintainer.exe > NUL 2>&1
taskkill /t /f /im smbx.exe > NUL 2>&1
echo.

set WGETBIN=tools\wget.exe
rem Use different binary for Windows XP
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "5.1" set WGETBIN=tools\wgetxp.exe
if "%version%" == "5.2" set WGETBIN=tools\wgetxp.exe

echo * (1/4) Downloading...
echo.

if not exist settings\NUL md settings

echo - Downloading update for PGE toolchain...
%WGETBIN% %PGE_WIN32ZIP% -O settings\pgezip.zip
if errorlevel 1 (
	echo Failed to download %PGE_WIN32ZIP%!
	pause
	goto quitAway
)

echo * (2/4) Extracting...
tools\unzip -o settings\pgezip.zip PGE_Project/* -d settings\PGE > NUL

echo * (3/4) Copying...
xcopy /E /C /Y /I settings\PGE\PGE_Project\* . > NUL
if errorlevel 1 (
	echo ======= ERROR! =======
	echo Some files can't be updated! Seems you still have opened some PGE applications
	echo Please close all of them and retry update again!
	echo ======================
	pause
	goto quitAway
)

echo * (4/4) Clean-up...
del /Q /F /S settings\pgezip.zip > NUL
rd /S /Q settings\PGE

echo.
echo Everything has been completed! ====

pause
:quitAway
