@echo off
net session >nul 2>&1 || powershell -Command "Start-Process '%~f0' -Verb runAs" && exit /b
where php >nul 2>&1 || (echo PHP not found. Install PHP first.& pause & exit /b 1)
where composer >nul 2>&1 || (
  php -r "copy('https://getcomposer.org/installer','composer-setup.php')"
  php -r "if(hash_file('sha384','composer-setup.php')!=='dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') exit(1)"
  php composer-setup.php --install-dir="%ProgramFiles%\Composer" --filename=composer.phar
  del composer-setup.php
  setx PATH "%ProgramFiles%\Composer;%PATH%" /M
)
set /p REPO_URL=Enter GitHub repository URL:
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $d=New-Object System.Windows.Forms.FolderBrowserDialog; if($d.ShowDialog() -eq 'OK'){Write-Output $d.SelectedPath}"`) do set "PROJECT_DIR=%%i"
composer global require laravel/installer
git clone "%REPO_URL%" "%PROJECT_DIR%"
cd /d "%PROJECT_DIR%"
composer update
copy /y ".env.example" ".env"
php artisan key:generate
php artisan migrate
pause
