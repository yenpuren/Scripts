<#####
About
Create a PowerShell script that can run either locally or remotely to get the system uptime. The script should also be able to output the result either locally or to a server.

.NOTES    
Name: server_uptime.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#####>

# Define the list of servers
$servers = @("COMP-01", "COMP-02", "COMP-03")

# Define the output CSV file
$outputCsv = ".\uptime_report.csv"

# Initialize an array to store the results
$results = @()

foreach ($server in $servers) {
    try {
        # Get the last boot time of the server
        $lastBootTime = Invoke-Command -ComputerName $server -ScriptBlock {
            (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
        }

        # Calculate the uptime
        $uptime = (Get-Date) - $lastBootTime

        $status = "Success"
        $message = "Uptime retrieved successfully"
    } catch {
        $lastBootTime = $null
        $uptime = $null
        $status = "Failed"
        $message = $_.Exception.Message
    }

    # Collect the result
    $results += [PSCustomObject]@{
        Server       = $server
        LastBootTime = $lastBootTime
        Uptime       = $uptime
        Status       = $status
        Message      = $message
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path $outputCsv -NoTypeInformation

Write-Output "Uptime check and report completed. Results saved to $outputCsv."
