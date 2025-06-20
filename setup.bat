@echo off
setlocal enabledelayedexpansion
net session >nul 2>&1
if errorlevel 1 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)
where php >nul 2>&1||call :err PHP not found. Install PHP first.
where git >nul 2>&1||call :err Git not found. Install Git first.
where composer >nul 2>&1||(
    powershell -Command "Invoke-WebRequest -UseBasicParsing 'https://getcomposer.org/installer' -OutFile composer-setup.php"
    for /f "delims=" %%h in ('php -r "echo hash_file('sha384','composer-setup.php');"') do set "hash=%%h"
    if not "!hash!"=="dac665f...b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6" call :err Composer installer corrupt.
    php composer-setup.php --install-dir="%ProgramFiles%\Composer" --filename=composer.phar
    del composer-setup.php
    setx PATH "%ProgramFiles%\Composer;%PATH%" /M
)
set "repo="
set /p repo=Enter GitHub repository URL: 
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $d=New-Object System.Windows.Forms.FolderBrowserDialog; $d.Description='Select destination folder'; $d.ShowNewFolderButton=$true; if($d.ShowDialog()-eq 'OK'){ Write-Output $d.SelectedPath }"`) do set "dir=%%i"
if not exist "%dir%" call :err Invalid destination folder.
composer global require laravel/installer||call :err Laravel installer install failed.
git clone "%repo%" "%dir%"||call :err Git clone failed.
cd /d "%dir%"
composer update||call :err Composer update failed.
copy /y ".env.example" ".env"
php artisan key:generate||call :err Key generation failed.
php artisan migrate --force||call :err Migration failed.
endlocal
goto :eof
:err
echo %*
pause
exit /b 1

