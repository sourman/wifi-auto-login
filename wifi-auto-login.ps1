param(
    [string]$NetworkSSID = "WirelessMississauga"
)

# Logging function
function Write-LoginLog {
    param([string]$Message)
    $logPath = "$env:TEMP\wifi-auto-login.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logPath -Value "[$timestamp] $Message"
}

# Network login function
function Invoke-NetworkLogin {
    try {
        # Captive portal login details from HAR file
        $loginUrl = "http://192.0.2.2/login.html"
        
        # Exact form parameters from HAR file
        $loginBody = @{
            buttonClicked = "4"
            redirect_url = "www.gstatic.com%2Fgenerate_204"
            err_flag = "0"
        }

        # Use Invoke-WebRequest with exact form parameters
        $loginResponse = Invoke-WebRequest -Uri $loginUrl -Method Post -Body $loginBody -ContentType "application/x-www-form-urlencoded" -UseBasicParsing

        Write-LoginLog "Login attempt completed. Status: $($loginResponse.StatusCode)"
        return $loginResponse.StatusCode -eq 200
    }
    catch {
        Write-LoginLog "Login failed: $_"
        return $false
    }
}

# Network change detection function
function Start-NetworkMonitor {
    Write-LoginLog "Starting network monitor for $NetworkSSID"

    # Create a WMI event watcher for network adapter status changes
    $query = "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_NetworkAdapter'"
    $watcher = New-Object System.Management.ManagementEventWatcher
    $watcher.Query = New-Object System.Management.WqlEventQuery($query)

    # Set up the event handler
    $watcher.EventArrived += {
        # Get current WiFi network
        $currentNetwork = (netsh wlan show interfaces | Select-String "SSID") -replace ".*: ", ""

        if ($currentNetwork -eq $NetworkSSID) {
            Write-LoginLog "Connected to $NetworkSSID. Initiating login..."
            $loginResult = Invoke-NetworkLogin
            
            if ($loginResult) {
                Write-LoginLog "Successfully logged into $NetworkSSID"
            } else {
                Write-LoginLog "Failed to log into $NetworkSSID"
            }
        }
    }

    # Start watching for events
    $watcher.Start()

    Write-LoginLog "Network monitor started. Waiting for network changes..."
    
    # Keep the script running and watching for events
    try {
        while ($true) {
            Start-Sleep -Seconds 3600
        }
    }
    finally {
        # Cleanup
        $watcher.Stop()
        $watcher.Dispose()
        Write-LoginLog "Network monitor stopped."
    }
}

# Start monitoring
Start-NetworkMonitor