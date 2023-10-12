# Server Health Check PowerShell Script for Multiple Servers

# Output file paths
$csvOutputPath = "C:\ServerHealthCheck.csv"
$htmlOutputPath = "C:\ServerHealthCheck.html"

# Get the list of servers from a .txt file
$servers = Get-Content -Path "C:\ServerList.txt"

# Get current date and time
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Initialize an array to store health check results
$healthCheckResults = @()

# Function to check server health
function Check-ServerHealth {
    param (
        [string]$serverName
    )

    # Test if the server is reachable
    $pingResult = Test-Connection -ComputerName $serverName -Count 1 -ErrorAction SilentlyContinue
    if ($pingResult) {
        # If the server is reachable, perform health checks
        $serverInfo = [PSCustomObject]@{
            ServerName = $serverName
            Timestamp  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        # Add your health check functions here (e.g., Check-OSDetails, Check-SystemUsage, etc.)

        # Example health checks:
        $osDetails = Get-WmiObject -ComputerName $serverName -Class Win32_OperatingSystem
        $serverInfo.OSName = $osDetails.Caption
        $serverInfo.OSVersion = $osDetails.Version
        $serverInfo.OSArchitecture = $osDetails.OSArchitecture

        $healthCheckResults += $serverInfo
    } else {
        Write-Host "Server $serverName is not reachable."
    }
}

# Loop through each server and perform health checks
foreach ($server in $servers) {
    Check-ServerHealth -serverName $server
}

# Export results to CSV
$healthCheckResults | Export-Csv -Path $csvOutputPath -NoTypeInformation

# Export results to HTML
$healthCheckResults | ConvertTo-Html -Property * -Title "Server Health Check - $currentTime" | Set-Content -Path $htmlOutputPath

# Display the results
$healthCheckResults

Write-Host "Server health check completed. CSV and HTML reports generated at $csvOutputPath and $htmlOutputPath."
