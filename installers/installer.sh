#!/bin/bash

set -e  # Exit on error
set -o pipefail

echo "==========================================================="
echo "  Netmig Installer - Linux/macOS (.sh)"
echo "==========================================================="

# Step 1: Check Python version
echo "[1/7] Checking for Python 3.7 or above..."
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python3 not found. Please install Python 3.7 or higher."
    read -p "Press Enter to close this window..."
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(sys.version_info.major)')
if [ "$PYTHON_VERSION" -lt 3 ]; then
    echo "ERROR: Python version must be 3.7 or higher."
    read -p "Press Enter to close this window..."
    exit 1
fi

# Step 2: Create Netmig directory
echo "[2/7] Creating Netmig directory..."
mkdir -p Netmig
cd Netmig

# Step 3: Create virtual environment
echo "[3/7] Creating virtual environment..."
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create virtual environment."
    read -p "Press Enter to close this window..."
    exit 1
fi

# Step 4: Activate virtual environment
echo "[4/7] Activating virtual environment..."
source venv/bin/activate

# Step 5: Download and extract repo
echo "[5/7] Downloading Netmig repo from GitHub..."
curl -L -o netmig.zip https://wwwin-github.cisco.com/sanjeekr/netmig-app/archive/refs/heads/master.zip
if [ ! -f netmig.zip ]; then
    echo "ERROR: Failed to download Netmig repo."
    read -p "Press Enter to close this window..."
    exit 1
fi

echo "[6/7] Extracting repo..."
unzip -q netmig.zip
mv netmig-app-master app
rm netmig.zip

# Step 7: Install dependencies
echo "[7/7] Installing Python dependencies..."
echo "Upgrading pip..."
python3 -m pip install --upgrade pip

echo "Installing Python dependencies..."
python3 -m pip install -r app/requirements.txt
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install Python dependencies."
    read -p "Press Enter to close this window..."
    exit 1
fi

# Final Step: Create launcher.sh
echo "Creating launcher.sh..."
cat << EOF > launcher.sh
#!/bin/bash
source "\$(dirname "\$0")/venv/bin/activate"
python3 app
EOF
chmod +x launcher.sh

echo
echo "Netmig installation completed successfully!"
echo "To launch Netmig, run ./launcher.sh inside the Netmig folder."

read -p "Press Enter to close this window..."
exit 0
