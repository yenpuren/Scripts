
<#
# Here is a PowerShell script that reads the list of servers from a text file and restarts them, providing an output in CSV.

Name: server_restart.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#>

# Define the path to the text file containing the list of servers
$serversFile = "C:\Servers.txt"

# Define the output CSV file
$outputFile = "C:\RestartResults.csv"

# Create a header row for the CSV file
$header = "ServerName,RestartStatus,RestartTime"
Add-Content -Path $outputFile -Value $header

# Read the list of servers from the text file
$servers = Get-Content -Path $serversFile

# Loop through each server and restart it
foreach ($server in $servers) {
    Write-Host "Restarting $server..." -ForegroundColor Green
    $restartResult = Restart-Computer -ComputerName $server -Force -ErrorAction Stop
    $restartStatus = if ($restartResult -eq "Success") {"Success"} else {"Failed"}
    $restartTime = Get-Date
    $output = "$server,$restartStatus,$restartTime"
    Add-Content -Path $outputFile -Value $output
    Write-Host "Restart result: $restartStatus" -ForegroundColor Green
}

Write-Host "Restart results saved to $outputFile"