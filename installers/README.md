
# Netmig Installers

This repository provides cross-platform installer scripts to set up the **Netmig** network automation tool on **Windows**, **Linux**, and **macOS**.

---

## 🔧 Features

- Checks for **Python 3.7+**
- Creates a **dedicated Netmig directory**
- Sets up a **Python virtual environment**
- Downloads and extracts the **Netmig app from GitHub**
- Installs dependencies via `requirements.txt`
- Creates a platform-specific **launcher script** to run the app

---

## 📦 Contents

```
netmig-installers/
├── README.md
├── win/
│   └── installer.bat
└── unix/
    └── installer.sh
```

---

## 🪟 Windows Installation

### ✅ Prerequisites
- Python 3.7 or higher installed and available in system PATH

### ▶️ Steps
1. Open **Command Prompt**
2. Navigate to the `win` directory:
   ```bat
   cd path\to\netmig-installers\win
   ```
3. Run the installer:
   ```bat
   installer.bat
   ```
4. On successful installation, launch Netmig using:
   ```bat
   launcher.bat
   ```

---

## 🐧 Linux / 🍎 macOS Installation

### ✅ Prerequisites
- Python 3.7 or higher
- `curl` or `wget`
- `unzip` utility

### ▶️ Steps
1. Open **Terminal**
2. Navigate to the `unix` directory:
   ```bash
   cd /path/to/netmig-installers/unix
   ```
3. Make the script executable:
   ```bash
   chmod +x installer.sh
   ```
4. Run the installer:
   ```bash
   ./installer.sh
   ```
5. On successful installation, launch Netmig using:
   ```bash
   ./launcher.sh
   ```

---

## 🛠 Troubleshooting

- Ensure Python is properly installed and available in your terminal.
- Make sure your system allows execution of shell or batch scripts.
- If installation fails, review the log messages printed during the script execution.

---

## 📬 Support

Please contact the Netmig development team for internal support or raise an issue on the internal GitHub repository.

---
