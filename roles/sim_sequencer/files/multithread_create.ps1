#  .\multithread_create.ps1 -count 100 -basepath "Y:\$(Get-Date -Format FileDateTime)\"

Param (
  [int]$count = 1000,
  [string][Parameter(Mandatory = $true )]$basepath
  )

$threads = (Get-WmiObject Win32_ComputerSystem).NumberofLogicalProcessors

Write-Host "Starting $threads parallels jobs at $(Get-Date)."

for ( $i = 0; $i -lt $threads; $i++ ) {
    $thisdir = "RUN$i"
    $thispath = $basepath + $thisdir
    if ( -not ( Test-Path -Path $thispath ) ) {
        New-Item -Path $basepath -Name $thisdir -ItemType "directory"
    }
            Start-Process -FilePath "powershell" -RedirectStandardOutput stdout.txt -RedirectStandardError stderr.txt -ArgumentList "-file c:\scripts\create_loop.ps1 -targetdirectory $thispath -count $count"
}
