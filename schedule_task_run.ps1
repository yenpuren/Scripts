<#####
About
A PowerShell script that can run specific schedule task locally or remotely. The script can also give the result output locally or on a server.

.NOTES    
Name: schedule_task_run.ps1
Author: Navanath Yenpure
Version	: 1.0
Date	: 15-May-2024
#####>

# Define the list of servers
$servers = @("Server1", "Server2", "Server3")

# Define the scheduled task name
$taskName = "\YourScheduledTaskName"

# Define the output CSV file
$outputCsv = "C:\path\to\your\output\scheduled_task_status.csv"

# Initialize an array to store the results
$results = @()

foreach ($server in $servers) {
    try {
        # Run the scheduled task using PsExec
        $psexecCommand = "psexec \\$server schtasks /run /tn $taskName"
        $output = Invoke-Expression -Command $psexecCommand

        # Check if the task started successfully
        if ($output -match "SUCCESS: Attempted to run the scheduled task") {
            $status = "Success"
            $message = "Scheduled task started successfully"
        } else {
            $status = "Failed"
            $message = "Scheduled task did not start successfully"
        }
    } catch {
        $status = "Failed"
        $message = $_.Exception.Message
    }

    # Collect the result
    $results += [PSCustomObject]@{
        Server  = $server
        TaskName = $taskName
        Status  = $status
        Message = $message
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path $outputCsv -NoTypeInformation

Write-Output "Scheduled task run and status report completed. Results saved to $outputCsv."
