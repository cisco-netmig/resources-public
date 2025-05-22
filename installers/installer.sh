#!/bin/bash

set -e

echo "==========================================================="
echo "   Netmig Installer - Linux/macOS (.sh)"
echo "==========================================================="

# Step 1: Prompt user
echo ""
echo "Select components to install:"
echo "  1. Netmig Application (core-app)"
echo "  2. Admin Tools (core-admin-tools)"
echo "  3. Both"
read -p "Enter choice (1/2/3): " choice

install_app=false
install_admin=false

case "$choice" in
  1) install_app=true ;;
  2) install_admin=true ;;
  3) install_app=true; install_admin=true ;;
  *) echo "Invalid choice. Exiting."; exit 1 ;;
esac

# Step 2: Check Python version
echo "[1/8] Checking Python 3.7+..."
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3.7+ is required but not found."
    exit 1
fi

PY_VER=$(python3 -c 'import sys; print(sys.version_info.major * 10 + sys.version_info.minor)')
if [ "$PY_VER" -lt 37 ]; then
    echo "ERROR: Python version must be 3.7 or higher."
    exit 1
fi

# Step 3: Create Netmig directory
echo "[2/8] Creating Netmig directory..."
mkdir -p Netmig
cd Netmig

# Step 4: Create virtual environment
echo "[3/8] Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Step 5: Download selected repos
if [ "$install_app" = true ]; then
    echo "[4/8] Downloading Netmig Application..."
    curl -L -o app.zip "https://wwwin-github.cisco.com/Netmig/core-app/archive/refs/heads/master.zip"
    unzip -q app.zip
    mv core-app-master app
    rm app.zip
fi

if [ "$install_admin" = true ]; then
    echo "[5/8] Downloading Admin Tools..."
    curl -L -o admin.zip "https://wwwin-github.cisco.com/Netmig/core-admin-tools/archive/refs/heads/master.zip"
    unzip -q admin.zip
    mv core-admin-tools-master admin
    rm admin.zip
fi

# Step 6: Upgrade pip
echo "[6/8] Upgrading pip..."
python3 -m pip install --upgrade pip

# Step 7: Install dependencies
if [ "$install_app" = true ] && [ -f app/requirements.txt ]; then
    echo "[7/8] Installing dependencies for Netmig App..."
    pip install -r app/requirements.txt
fi

if [ "$install_admin" = true ] && [ -f admin/requirements.txt ]; then
    echo "[7/8] Installing dependencies for Admin Tools..."
    pip install -r admin/requirements.txt
fi

# Step 8: Create launchers
if [ "$install_app" = true ]; then
    echo "Creating app-launcher.sh..."
    cat <<EOF > app-launcher.sh
#!/bin/bash
source "\$(dirname "\$0")/venv/bin/activate"
python3 app
EOF
    chmod +x app-launcher.sh
fi

if [ "$install_admin" = true ]; then
    echo "Creating admin-launcher.sh..."
    cat <<EOF > admin-launcher.sh
#!/bin/bash
source "\$(dirname "\$0")/venv/bin/activate"
python3 admin
EOF
    chmod +x admin-launcher.sh
fi

# Done
echo ""
echo "==========================================================="
echo "Netmig installation completed successfully!"
[ "$install_app" = true ] && echo "- Run ./app-launcher.sh to launch the Netmig App"
[ "$install_admin" = true ] && echo "- Run ./admin-launcher.sh to launch Admin Tools"
echo "==========================================================="
