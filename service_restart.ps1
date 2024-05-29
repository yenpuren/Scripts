<#####
About
A PowerShell script that can restart specific service(s) locally or remotely. The script can also be used to see what services are currently running locally or on a server.

.NOTES    
Name: service_restart.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#####>

# Define the list of servers
$servers = @("Server1", "Server2", "Server3")

# Define the service name
$serviceName = "YourServiceName"

# Define the output CSV file
$outputCsv = "C:\path\to\your\output\status_report.csv"

# Initialize an array to store the results
$results = @()

foreach ($server in $servers) {
    try {
        # Restart the service
        Invoke-Command -ComputerName $server -ScriptBlock {
            param ($serviceName)
            Restart-Service -Name $serviceName -Force
            Start-Sleep -Seconds 5
            $svc = Get-Service -Name $serviceName
            return $svc.Status
        } -ArgumentList $serviceName

        $status = "Success"
        $message = "Service restarted successfully"
    } catch {
        $status = "Failed"
        $message = $_.Exception.Message
    }

    # Collect the result
    $results += [PSCustomObject]@{
        Server  = $server
        Service = $serviceName
        Status  = $status
        Message = $message
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path $outputCsv -NoTypeInformation

Write-Output "Service restart and status report completed. Results saved to $outputCsv."
