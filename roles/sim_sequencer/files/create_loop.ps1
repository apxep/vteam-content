# create loop
Param (
  [int]$count = 1000,
  [string][Parameter(Mandatory = $true )]$targetdirectory
  )

Start-Transcript -path output.txt -append

for ( $thiscount = 0; $thiscount -lt $count; $thiscount++ ) {
    $filecount = '{0:d6}' -f [int]$thiscount
    Write-Host Write: $thiscount
    Set-Content -Path $targetdirectory\FILE$filecount.OUT -Value ( acgt )
}

for ( $thiscount = 0; $thiscount -lt $count; $thiscount++ ) {
    $filecount = '{0:d6}' -f [int]$thiscount
    Write-Host Read: $thiscount
    Get-FileHash -Algorithm MD5 $targetdirectory\FILE$filecount.OUT
}

Stop-Transcript
