@echo off
:: Check if running as admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ========================================
    echo   ERROR: This script must be run as administrator.
    echo   Right-click and choose "Run as administrator"
    echo ========================================
    pause
    exit /b
)

setlocal

echo.
echo === Step 1: Add Registry Keys to Bypass Windows 11 Checks ===
REG ADD "HKLM\SYSTEM\Setup\LabConfig" /v BypassTPMCheck /t REG_DWORD /d 1 /f
REG ADD "HKLM\SYSTEM\Setup\LabConfig" /v BypassRAMCheck /t REG_DWORD /d 1 /f
REG ADD "HKLM\SYSTEM\Setup\LabConfig" /v BypassSecureBootCheck /t REG_DWORD /d 1 /f
REG ADD "HKLM\SYSTEM\Setup\LabConfig" /v BypassCPUCheck /t REG_DWORD /d 1 /f
REG ADD "HKLM\SYSTEM\Setup\LabConfig" /v BypassStorageCheck /t REG_DWORD /d 1 /f
REG ADD "HKLM\SYSTEM\Setup\MoSetup" /v AllowUpgradesWithUnsupportedTPMOrCPU /t REG_DWORD /d 1 /f

echo Registry keys set.

echo.
echo === Step 2: Mount ISO File via PowerShell ===
echo Scanning folder: %~dp0
cd /d %~dp0
dir /b *.iso
for %%i in (*.iso) do (
    set "ISOPath=%%~fi"
    echo Found ISO: %%~fi
    goto :foundiso
)
echo ERROR: No ISO file found in this folder.
goto :end

:foundiso
powershell -NoProfile -Command ^
    "Mount-DiskImage -ImagePath '%ISOPath%' -PassThru | Get-Volume | Select -ExpandProperty DriveLetter > driveletter.txt"

if not exist driveletter.txt (
    echo ERROR: Failed to mount ISO.
    goto :end
)

:: Step 3 - Find Mounted ISO Drive
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\setup.exe" (
        set "ISODrive=%%d:"
        goto foundsetup
    )
)

echo ERROR: setup.exe not found on any drive. Exiting.
goto :end

:foundsetup
echo Found setup.exe on drive %ISODrive%
echo Launching setup...
"%ISODrive%\setup.exe" /auto upgrade /dynamicupdate disable /eula accept /showoobe none


:end
endlocal
pause
