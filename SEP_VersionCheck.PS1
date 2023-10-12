# Read the list of servers from a text file
$servers = Get-Content -Path "servers.txt"

# Create an array to store the results
$results = @()

# Iterate through the list of servers
foreach ($server in $servers) {
    $serverInfo = @{
        "ServerName" = $server
        "OS" = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $server).Caption
        "TotalMemoryGB" = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $server).TotalPhysicalMemory / 1GB
    }
    
    $results += New-Object PSObject -Property $serverInfo
}

# Export the results to a CSV file
$results | Export-Csv -Path "ServerInfo.csv" -NoTypeInformation

# Export the results to an HTML file
$results | ConvertTo-Html | Out-File -FilePath "ServerInfo.html"
