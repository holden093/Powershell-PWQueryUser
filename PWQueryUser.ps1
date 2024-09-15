function PWQueryUser {
    
    param (
        [string]$serverName
    )
    
    $Data = quser /server:$serverName 2> $null
    if ($null -eq $Data) {
        Write-Host "`nNo users connected to $serverName"
        return
    }
    $Null = $Data[0] -match "\s(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+\s\w+)\s+(\w+\s\w+)"
    $Headers = $matches[1..6]
    $Lines = $Data[1..($Data.Length - 1)]
    $RDSessions = $Lines | ForEach-Object {
        $Null = $_ -match "\s(\w+)\s+(.+)?\s+(\d+)\s+(\w+)\s+(.+)\s+(.+\s.+)"
        $Values = $matches[1..6]
        $Object = New-Object PSObject -Property @{
            $Headers[0] = $Values[0]
            $Headers[1] = $Values[1]
            $Headers[2] = $Values[2]
            $Headers[3] = $Values[3]
            $Headers[4] = $Values[4]
            $Headers[5] = $Values[5]
        }
        $Object
    }

    return $RDSessions

}

$username = [Environment]::UserName

$servers = (Import-Csv -Path .\computers.csv).hostnames

foreach ($server in $servers) {
    $sessions = PWQueryUser -serverName $server
    if ($null -eq $sessions) {continue}
    Write-Host "`nSessions on $server"
    $sessions | Format-Table
    foreach ($session in $sessions) {

        if ($session.'IDLE TIME' -match '`.'){continue}
        elseif (($session.'IDLE TIME' -match '\d+`+\d+:\d+') -and ($session.USERNAME -like $username)) {
            Write-Host "Logging off session $($session.USERNAME) on $server"
            logoff $session.'ID' /server:$server
        }
        elseif (($session.'IDLE TIME' -match '(\d+):\d+') -and ($session.USERNAME -like $username)) {
            $hours = $matches[1]
            if ([int]$hours -gt 10) {
                Write-Host "Logging off session $($session.USERNAME) on $server"
                logoff $session.'ID' /server:$server
            }
        }    
    }
}

Write-Host "`nDone`n"