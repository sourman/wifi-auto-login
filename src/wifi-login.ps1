param(
    [string[]]$NetworksToLogin = @("LibraryWiFi", "CampusNet")
)

# Logging function
function Write-Log {
    param([string]$Message)
    $logPath = Join-Path $PSScriptRoot "..\logs\wifi-login.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logPath -Value "[$timestamp] $Message"
}

# Network login function (generic template)
function Invoke-NetworkLogin {
    param([string]$NetworkName)

    try {
        # Placeholder for network-specific login logic
        switch ($NetworkName) {
            "LibraryWiFi" {
                # Example REST API call for LibraryWiFi
                $loginResponse = Invoke-RestMethod -Uri "https://library-wifi-portal.com/login" -Method Post -Body @{
                    username = "your_username"
                    password = "your_password"
                }
                Write-Log "Attempted login for LibraryWiFi: $($loginResponse.status)"
            }
            "CampusNet" {
                # Different login mechanism for CampusNet
                $loginResponse = Invoke-WebRequest -Uri "https://campus-net-portal.edu/authenticate" -Method Post -Body @{
                    credentials = "campus_credentials"
                }
                Write-Log "Attempted login for CampusNet: $($loginResponse.StatusCode)"
            }
            default {
                Write-Log "No login configuration for network: $NetworkName"
            }
        }
    }
    catch {
        Write-Log "Login error for $NetworkName: $($_.Exception.Message)"
    }
}

# Main network monitoring loop
function Start-NetworkMonitor {
    $previousNetwork = $null

    while ($true) {
        $currentNetwork = (Get-NetConnectionProfile).Name

        if ($currentNetwork -ne $previousNetwork) {
            Write-Log "Network changed to: $currentNetwork"

            if ($NetworksToLogin -contains $currentNetwork) {
                Invoke-NetworkLogin -NetworkName $currentNetwork
            }

            $previousNetwork = $currentNetwork
        }

        Start-Sleep -Seconds 30  # Check every 30 seconds
    }
}

# Start monitoring
Start-NetworkMonitor 