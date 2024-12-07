# Requires Administrator Privileges
param(
    [string]$ScriptPath = "$PSScriptRoot\wifi-auto-login.ps1"
)

# Check for admin rights
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator"
    exit 1
}

# Service configuration
$serviceName = "WirelessMississaugaLogin"
$serviceDescription = "Automatically logs into WirelessMississauga network"

# Create Windows service
New-Service -Name $serviceName `
    -DisplayName $serviceName `
    -Description $serviceDescription `
    -StartupType Automatic `
    -BinaryPathName "powershell.exe -ExecutionPolicy Bypass -File `"$ScriptPath`""

# Start the service
Start-Service -Name $serviceName

Write-Host "WiFi Auto Login service installed successfully for WirelessMississauga network!"

# Optional: Add service removal command
Write-Host "To remove the service, run: Remove-Service -Name `"$serviceName`"" 