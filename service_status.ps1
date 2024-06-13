<#
# Here is a PowerShell script that gets the status of a specific service on multiple servers and outputs the results to a CSV file.

Name: service_status.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#>

# Define the list of servers to check
$servers = Get-Content -Path "C:\Servers.txt"

# Define the service name to check
$serviceName = "MyService"

# Define the output CSV file
$outputFile = "C:\ServiceStatus.csv"

# Create a header row for the CSV file
$header = "ServerName,ServiceName,ServiceStatus"
Add-Content -Path $outputFile -Value $header

# Loop through each server and get the service status
foreach ($server in $servers) {
    Write-Host "Checking service status on $server..." -ForegroundColor Green
    $service = Get-Service -ComputerName $server -Name $serviceName -ErrorAction SilentlyContinue
    if ($service) {
        $serviceStatus = $service.Status
    } else {
        $serviceStatus = "Not Found"
    }
    $output = "$server,$serviceName,$serviceStatus"
    Add-Content -Path $outputFile -Value $output
    Write-Host "Service status: $serviceStatus" -ForegroundColor Green
}

Write-Host "Service status results saved to $outputFile"