
# Netmig Installer Guide

This guide explains how to install and launch the **Netmig Network Automation Tool** using platform-specific installer scripts.

---

## Windows Installation (`installer.bat`)

### Requirements
- Windows 10 or later
- Python 3.7 or higher (Ensure `python` is added to your PATH)
- **Cisco VPN access** (to access internal GitHub Enterprise repositories)

### Steps
1. **[Download netmig-installer.bat](https://wwwin-github.cisco.com/Netmig/resources-public/blob/master/installers/installer.bat)**
2. Ensure you're connected to the **Cisco VPN**.
3. Double-click `installer.bat` or run it via **Command Prompt**:
   ```cmd
   installer.bat
   ```
4. When prompted, choose one of the following:
   - `1` — Install **Netmig App** only
   - `2` — Install **Admin Tools** only
   - `3` — Install **Both**

5. The script will:
   - Create a `Netmig/` directory
   - Set up a shared Python virtual environment
   - Download and extract selected components from Cisco GitHub
   - Install Python dependencies
   - Create launchers: `app-launcher.bat` and/or `admin-launcher.bat`

### Launch

Run the launcher from inside the `Netmig` folder:

```cmd
app-launcher.bat       :: Launch Netmig App
admin-launcher.bat     :: Launch Admin Tools
```

---

## Linux/macOS Installation (`installer.sh`)

### Requirements
- Python 3.7+ (with `python3` and `pip`)
- `curl`, `unzip`
- Bash-compatible shell (default on macOS and most Linux distros)
- **Cisco VPN access**


### Steps
1. **[Download netmig-installer.sh](https://wwwin-github.cisco.com/Netmig/resources-public/blob/master/installers/installer.sh)**
2. Ensure you're connected to the **Cisco VPN**.
3. Open a terminal and make the script executable:

   ```bash
   chmod +x installer.sh
   ./installer.sh
   ```

4. Choose one of the following:
   - `1` — Netmig App only
   - `2` — Admin Tools only
   - `3` — Both

5. The script will:
   - Create a `Netmig/` directory
   - Set up a shared virtual environment (`venv/`)
   - Download and extract selected components from Cisco GitHub
   - Install dependencies via `pip`
   - Create launchers: `app-launcher.sh` and/or `admin-launcher.sh`

### Launch

```bash
./app-launcher.sh       # Launch Netmig App
./admin-launcher.sh     # Launch Admin Tools
```

---

## Output Directory Structure (Example)

```
Netmig/
├── venv/                  # Shared Python virtual environment
├── app/                   # Netmig App code
├── admin/                 # Admin Tools code
├── app-launcher.bat/.sh   # Platform-specific launcher
├── admin-launcher.bat/.sh
```

---

## Troubleshooting

- **Python not found**: Install Python 3.7+ and ensure it is in your PATH.
- **VPN not connected**: Verify Cisco VPN is active; GitHub Enterprise URLs require VPN.
- **Permission denied** (Linux/macOS): Use `chmod +x installer.sh` to make the script executable.
