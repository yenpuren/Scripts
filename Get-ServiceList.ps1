<#
# Here is a PowerShell script that gets Service List from a list of servers in a text file and outputs the results to a CSV file.

Name: Get-ServiceList.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#>

# Import the list of servers from a text file
$servers = Get-Content -Path "C:\Path\To\Servers.txt"

# Create an empty array to store the service list
$serviceList = @()

# Loop through each server
foreach ($server in $servers) {
  # Get the list of services on the current server
  $services = Get-Service -ComputerName $server -ErrorAction SilentlyContinue
  
  # Loop through each service
  foreach ($service in $services) {
    # Create a custom object to store the service information
    $serviceObject = [PSCustomObject]@{
      Server = $server
      ServiceName = $service.Name
      ServiceStatus = $service.Status
    }
    
    # Add the service object to the service list array
    $serviceList += $serviceObject
  }
}

# Export the service list to a CSV file
$serviceList | Export-Csv -Path "C:\Path\To\ServiceList.csv" -NoTypeInformation