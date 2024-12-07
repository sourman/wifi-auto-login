# WiFi Auto Login Service

## Overview
Automatically logs into the WirelessMississauga network when connected.

## Prerequisites
- Windows 10/11
- PowerShell 5.1 or later
- Administrator privileges

## Installation
1. Ensure the script is placed in an accessible location
2. Run the script with administrator privileges

## Usage
powershell
.\wifi-auto-login.ps1
```

## Customization
- Modify the `$NetworkSSID` parameter to target a different network
- Adjust the login URL and parameters in `Invoke-NetworkLogin` function if needed

## Logging
Login attempts and network changes are logged to `%TEMP%\wifi-auto-login.log`

## Troubleshooting
- Check the log file for detailed information about login attempts
- Ensure network login URL and parameters are correct
- Verify network connectivity

## Security
- Do not share or commit the script with sensitive login details
- Review and update login parameters as needed
```