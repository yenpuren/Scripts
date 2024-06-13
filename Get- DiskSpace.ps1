<#
# Here is a PowerShell script that gets disk space details from a list of servers in a text file and outputs the results to a CSV file.

Name: Get-DiskSpace.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#>

# Import the list of servers from a text file
$servers = Get-Content -Path "C:\Path\To\Servers.txt"

# Create an empty array to store the results
$results = @()

# Loop through each server
foreach ($server in $servers) {
  # Get the disk space information for the server
  $diskSpace = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $server -Filter "DriveType = 3"

  # Loop through each disk
  foreach ($disk in $diskSpace) {
    # Create a custom object to store the results
    $result = [PSCustomObject]@{
      Server = $server
      Drive = $disk.Name
      SizeGB = $disk.Size / 1GB
      FreeGB = $disk.FreeSpace / 1GB
      PercentFree = ($disk.FreeSpace / $disk.Size) * 100
    }

    # Add the result to the array
    $results += $result
  }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\Path\To\DiskSpaceReport.csv" -NoTypeInformation