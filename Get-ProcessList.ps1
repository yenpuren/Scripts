<#
# Here is a PowerShell script that gets Process List from a list of servers in a text file and outputs the results to a CSV file.

Name: Get-ProcessList.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#>

# Import the list of servers from a text file
$servers = Get-Content -Path "C:\Path\To\Servers.txt"

# Create an empty array to store the process lists
$processLists = @()

# Loop through each server
foreach ($server in $servers) {
  # Get the process list for the current server
  $processList = Invoke-Command -ComputerName $server -ScriptBlock { Get-Process }
  
  # Add the server name to each process object
  $processList | ForEach-Object { $_ | Add-Member -MemberType NoteProperty -Name "Server" -Value $server }
  
  # Add the process list to the overall array
  $processLists += $processList
}

# Export the process lists to a CSV file
$processLists | Export-Csv -Path "C:\Path\To\ProcessList.csv" -NoTypeInformation