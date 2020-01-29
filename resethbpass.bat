@echo off
rem Reset Password for hummingbot windows binary
rem created by: PtrckM
rem 
rem usage: download file https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/resethbpass.bat
rem
cls
echo.
echo [*] -- Reset Password - HB windows binary build v1
echo [-] 
echo [*] -- Warning: This will delete encrypted api+key+secret files and wallet keyfiles.
echo [*] --          Created wallet thru hummingbot will be lost and cannot be used again,
echo [*] --          you have been warned...
echo [-] 
timeout /T 5
echo.
echo [*] -- listing files...
echo. 
dir /b %localappdata%\hummingbot.io\hummingbot\conf\encrypted* %localappdata%\hummingbot.io\hummingbot\conf\key_file*
echo.
echo [*] -- this files will be deleted in order to reset password...
:choice
set /P c=[-] -- Are you sure you want to continue (y/n)? 
if /I "%c%" EQU "Y" goto :somewhere
if /I "%c%" EQU "N" goto :somewhere_else
goto :choice

:somewhere

echo [*] -- Removing files...
del /f /q %localappdata%\hummingbot.io\hummingbot\conf\encrypted*.json
del /f /q %localappdata%\hummingbot.io\hummingbot\conf\key_file*.json
echo [*] -- operation success, password has been reset...
echo.
pause
exit

:somewhere_else

echo [*] -- operation aborted... exiting!
echo.
pause
exit
