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

Invoke-NetworkLogin