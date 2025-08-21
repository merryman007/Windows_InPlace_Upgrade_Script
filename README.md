# Windows_InPlace_Upgrade_Script
Automation script for performing Windows In-place Upgrades

This is a batch script that automates the Windows 10/11 in-place upgrade process.  
It bypasses compatibility checks (TPM, CPU, RAM, Secure Boot, etc.), mounts the Windows ISO, and launches `setup.exe` with the required parameters.

---

## Features
- Checks if script is run as Administrator.
- Adds registry keys to bypass Windows 11 hardware checks.
- Automatically mounts the ISO in the script directory.
- Detects `setup.exe` on the mounted drive.
- Runs upgrade with unattended options (`/auto upgrade /dynamicupdate disable /eula accept /showoobe none`).

---

## Requirements
- Run as **Administrator**.
- Windows 10 or 11 system.
- A Windows 10/11 ISO file in the **same folder** as the script.
- The ISO must be in the same language pack as the host OS you are migrating from, else user apps and setting will not migrate

---

## Usage
1. Place your Windows ISO file in the same folder as this script.  
2. Right-click the script and select **Run as Administrator**.  
3. Script will:
   - Set registry keys to bypass checks.
   - Mount the ISO automatically.
   - Launch the upgrade process.

---

## Notes & Troubleshooting Known Issues
If no ISO is detected, script exits with an error.
You may encounter the “We couldn’t update system reserved partition” error installing Windows 11.
This is caused by the EFI partiton not having enough free space. You can temporarily fix this by running the code snippet below in elevated CMD terminal:

"
mountvol y: /s
y:
cd EFI\Microsoft\Boot\Fonts
del*

"
The system may ask you if you are sure to continue, press Y and then Enter to continue.
If the above code snippet doesn't work, kindly use AOMEI free Standard edition to resize/expand the EFI partition to 1GB.

Make sure you have enough free disk space.

The script disables dynamic updates to speed up the process — you can remove /dynamicupdate disable if you prefer downloading latest updates during install.


Contribution
Feel free to fork this repo, suggest improvements, or open a PR if you’d like to add functionality.
