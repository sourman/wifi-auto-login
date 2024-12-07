# Requires Administrator Privileges
param(
    [string]$ServiceName = "WiFiAutoLogin",
    [string]$ScriptPath = "$PSScriptRoot\wifi-login.ps1"
)

# Check for admin rights
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator"
    exit
}

# Create Windows Service
New-Service -Name $ServiceName `
    -DisplayName "WiFi Auto Login Service" `
    -Description "Automatically logs into predefined WiFi networks" `
    -StartupType Automatic `
    -BinaryPathName "powershell.exe -ExecutionPolicy Bypass -File `"$ScriptPath`""

# Start the service
Start-Service -Name $ServiceName

Write-Host "WiFi Auto Login Service installed successfully!" 