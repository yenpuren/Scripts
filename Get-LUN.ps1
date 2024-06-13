<#
# Here is a PowerShell script that gets disk details and LUN details from a list of servers in a text file and outputs the results to a CSV file.

Name: get-LUN.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#>

# Import the list of servers from the text file
$servers = Get-Content -Path "C:\Servers.txt"

# Create an empty array to store the results
$results = @()

# Loop through each server
foreach ($server in $servers) {
  # Get the disk details
  $disks = Get-WmiObject -Class Win32_DiskDrive -ComputerName $server
  
  # Loop through each disk
  foreach ($disk in $disks) {
    # Get the LUN details
    $lun = Get-WmiObject -Class Win32_DiskDriveToDiskPartition -ComputerName $server | 
      Where-Object {$_.DiskDrive.DeviceID -eq $disk.DeviceID} | 
      ForEach-Object {$_.DiskPartition}
    
    # Create a custom object to store the results
    $result = [PSCustomObject]@{
      Server = $server
      DiskNumber = $disk.Index
      DiskSize = $disk.Size
      DiskModel = $disk.Model
      LUN = $lun.Name
      LUNSize = $lun.Size
    }
    
    # Add the result to the array
    $results += $result
  }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\DiskDetails.csv" -NoTypeInformation