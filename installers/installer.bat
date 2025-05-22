@echo off
setlocal enabledelayedexpansion

echo ===========================================================
echo   Netmig Installer - Windows (.bat)
echo ===========================================================

:: Step 1: Prompt user for installation choice
:select_option
echo.
echo Select components to install:
echo   1. Netmig Application (core-app)
echo   2. Admin Tools (core-admin-tools)
echo   3. Both
set /p choice=Enter choice (1/2/3):

if "%choice%"=="1" (
    set install_app=true
    set install_admin=false
) else if "%choice%"=="2" (
    set install_app=false
    set install_admin=true
) else if "%choice%"=="3" (
    set install_app=true
    set install_admin=true
) else (
    echo Invalid choice. Try again.
    goto select_option
)

:: Step 2: Check Python version
echo [1/8] Checking for Python 3.7 or above...
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python not found. Please install Python 3.7 or higher.
    goto :wait_and_exit
)

FOR /F "tokens=2 delims=." %%a IN ('python -V 2^>^&1') DO SET VER=%%a
IF !VER! LSS 3 (
    echo ERROR: Python version must be 3.7 or higher.
    goto :wait_and_exit
)

:: Step 3: Create Netmig directory
echo [2/8] Creating Netmig directory...
mkdir Netmig 2>nul
cd Netmig

:: Step 4: Create virtual environment
echo [3/8] Creating virtual environment...
python -m venv venv
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create virtual environment.
    goto :wait_and_exit
)

:: Step 5: Activate venv
echo [4/8] Activating virtual environment...
call venv\Scripts\activate.bat

:: Step 6: Download selected repos
if !install_app! == true (
    echo [5/8] Downloading Netmig Application...
    powershell -Command "Invoke-WebRequest -Uri 'https://wwwin-github.cisco.com/Netmig/core-app/archive/refs/heads/master.zip' -OutFile 'app.zip'"
    IF NOT EXIST app.zip (
        echo ERROR: Failed to download Netmig Application.
        goto :wait_and_exit
    )
    echo Extracting Application...
    powershell -Command "Expand-Archive -Path 'app.zip' -DestinationPath '.'"
    move core-app-master app >nul
    del app.zip
)

if !install_admin! == true (
    echo [6/8] Downloading Admin Tools...
    powershell -Command "Invoke-WebRequest -Uri 'https://wwwin-github.cisco.com/Netmig/core-admin-tools/archive/refs/heads/master.zip' -OutFile 'admin.zip'"
    IF NOT EXIST admin.zip (
        echo ERROR: Failed to download Admin Tools.
        goto :wait_and_exit
    )
    echo Extracting Admin Tools...
    powershell -Command "Expand-Archive -Path 'admin.zip' -DestinationPath '.'"
    move core-admin-tools-master admin >nul
    del admin.zip
)

:: Step 7: Install dependencies
echo [7/8] Upgrading pip...
python -m pip install --upgrade pip

if exist app\requirements.txt (
    echo Installing dependencies for Netmig App...
    python -m pip install -r app\requirements.txt
    IF %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install App dependencies.
        goto :wait_and_exit
    )
)

if exist admin\requirements.txt (
    echo Installing dependencies for Admin Tools...
    python -m pip install -r admin\requirements.txt
    IF %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install Admin dependencies.
        goto :wait_and_exit
    )
)

:: Step 8: Create launchers
if exist app (
    echo Creating app-launcher.bat...
    (
    echo @echo off
    echo call %%~dp0venv\Scripts\activate.bat
    echo python app
    ) > app-launcher.bat
)

if exist admin (
    echo Creating admin-launcher.bat...
    (
    echo @echo off
    echo call %%~dp0venv\Scripts\activate.bat
    echo python admin
    ) > admin-launcher.bat
)

:: Final
echo.
echo ===========================================================
echo Netmig installation completed successfully!
if !install_app! == true echo - Use app-launcher.bat to run the Netmig App.
if !install_admin! == true echo - Use admin-launcher.bat to run Admin Tools.
echo ===========================================================
goto :wait_and_exit

:wait_and_exit
echo.
echo Press Enter to close this window...
pause >nul
exit /b
