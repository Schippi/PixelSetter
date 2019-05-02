@echo off
:: Get ADMIN Privs
mkdir "%windir%\BatchGotAdmin"
if '%errorlevel%' == '0' (
  rmdir "%windir%\BatchGotAdmin" & goto gotAdmin
) else ( goto UACPrompt )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute %0, "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: End Get ADMIN Privs
:: Read registry to find paint.net install directory
reg query HKLM\SOFTWARE\Paint.NET /v TARGETDIR 2>nul || (echo Sorry, I can't find paint.net! & goto fail)
set PDN_DIR=
for /f "tokens=2,*" %%a in ('reg query HKLM\SOFTWARE\Paint.NET /v TARGETDIR ^| findstr TARGETDIR') do (
  set PDN_DIR=%%b
)
if not defined PDN_DIR (echo Sorry, I can't find paint.net! & goto fail)
:: End read registry
:: Now do install
@echo off
cls
echo.
echo Installing Pixelsetter.dll to %PDN_DIR%\Effects\
echo.
copy /y "Pixelsetter.dll" "%PDN_DIR%\Effects\"
if '%errorlevel%' == '0' (
goto success
) else (
goto fail
)
:success
echo.
echo    _____ _    _  _____ _____ ______  _____ _____  _ 
echo   / ____) !  ! !/  ___)  ___)  ____)/ ____) ____)! !
echo  ( (___ ! !  ! !  /  /  /   ! (__  ( (___( (___  ! !
echo   \___ \! !  ! ! (  (  (    !  __)  \___ \\___ \ ! !
echo   ____) ) !__! !  \__\  \___! (____ ____) )___) )!_!
echo  (_____/ \____/ \_____)_____)______)_____/_____/ (_)
goto done
:fail
echo.
echo  _____       _____ _      _ 
echo !  ___)/\   (_   _) !    ! !
echo ! (__ /  \    ! ! ! !    ! !
echo !  __) /\ \   ! ! ! !    ! !
echo ! ! / ____ \ _! !_! !___ !_!
echo !_!/_/    \_\_____)_____)(_)
echo.
echo Close Paint.NET and try installing again.
:done
echo.
pause
