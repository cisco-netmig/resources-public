@echo off
setlocal enabledelayedexpansion

echo ===========================================================
echo   Netmig Installer - Windows (.bat)
echo ===========================================================

:: Step 1: Check Python version
echo [1/7] Checking for Python 3.7 or above...
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

:: Step 2: Create Netmig directory
echo [2/7] Creating Netmig directory...
mkdir Netmig 2>nul
cd Netmig

:: Step 3: Create virtual environment
echo [3/7] Creating virtual environment...
python -m venv venv
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create virtual environment.
    goto :wait_and_exit
)

:: Step 4: Activate venv
echo [4/7] Activating virtual environment...
call venv\Scripts\activate.bat

:: Step 5: Download and extract repo
echo [5/7] Downloading Netmig repo from GitHub...
powershell -Command "Invoke-WebRequest -Uri 'https://wwwin-github.cisco.com/Netmig/core-app/archive/refs/heads/master.zip' -OutFile 'netmig.zip'"
IF NOT EXIST netmig.zip (
    echo ERROR: Failed to download Netmig repo.
    goto :wait_and_exit
)

echo [6/7] Extracting repo...
powershell -Command "Expand-Archive -Path 'netmig.zip' -DestinationPath '.'"
move netmig-app-master app >nul
del netmig.zip

:: Step 7: Install dependencies
echo [7/7] Installing Python dependencies...
echo Upgrading pip...
python -m pip install --upgrade pip

echo Installing Python dependencies...
python -m pip install -r app\requirements.txt
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install Python dependencies.
    goto :wait_and_exit
)

:: Final Step: Create launcher.bat
echo Creating launcher.bat...
(
echo @echo off
echo call %%~dp0venv\Scripts\activate.bat
echo python app
) > launcher.bat

echo.
echo Netmig installation completed successfully!
echo To launch Netmig, run launcher.bat inside the Netmig folder.
goto :wait_and_exit

:wait_and_exit
echo.
echo Press Enter to close this window...
pause >nul
exit /b
