# table is int(sequence),datetime,varcahr(MAX),varchar(50)

while( $true ) {

# PROD or DR
$site = "DR"

$lastboot = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime

$currentdate = Get-Date

$uptime = $currentdate - $lastboot

$upstring = "$($uptime.days) Days, $($uptime.hours) Hrs, $($uptime.minutes) Min, and $($uptime.seconds) Sec"

#TO-DO: fix ServerInstance to variable or local host name
Invoke-Sqlcmd -ServerInstance "JHTYLW03" -Database tpcc -Query "INSERT INTO dbo.timeseries VALUES (NEXT VALUE FOR timeseries_seq,'$(( Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime)','$upstring','$site');"

Invoke-Sqlcmd -ServerInstance "JHTYLW03" -Database tpcc -Query "SELECT * FROM dbo.timeseries ORDER BY sequence DESC OFFSET 0 ROWS FETCH FIRST 80 ROWS ONLY;"

Start-Sleep -Seconds 5

}


 

