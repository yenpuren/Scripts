<#
# Here is an example of how you can use PowerShell to get server information for multiple servers listed in a text file and output the results to a CSV file.

Name: Get-ServerInfo.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#>

# Import the list of servers from the text file
$servers = Get-Content -Path "C:\Path\To\servers.txt"

# Create an empty array to store the results
$results = @()

# Loop through each server and get the information
foreach ($server in $servers) {
    $serverInfo = [PSCustomObject]@{
        ServerName = $server
        OS = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $server).Caption
        CPU = (Get-WmiObject -Class Win32_Processor -ComputerName $server).Name
        RAM = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $server).TotalPhysicalMemory / 1GB
        DiskSpace = (Get-WmiObject -Class Win32_LogicalDisk -ComputerName $server -Filter "DriveType = 3").FreeSpace / 1GB
    }
    $results += $serverInfo
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\Path\To\server_info.csv" -NoTypeInformation