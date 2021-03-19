[CmdletBinding()]

Param (
  [string][Parameter(Mandatory = $true)]$initiator_ips,
  [string][Parameter(Mandatory = $true)]$target_ips
)

Trap
{
	$_
	Exit 1
}
$ErrorActionPreference = "Stop"

$initiators = $initiator_ips.Split(",")

$targets = $target_ips.Split(",")

$init_targ_pair = @()

Write-Host "Checking connectivity between this host's ports and the target ports"

foreach ( $this_init in $initiators ) {
    foreach ( $this_targ in $targets ) {
        Write-Host "I: $this_init T: $this_targ"
        $this_result = Test-NetConnection -ComputerName $this_targ
        if ($this_result.PingSucceeded -and ( $this_result.SourceAddress.IPAddress -eq $this_init ) ) {
            $init_targ_pair += "$this_init,$this_targ"
        }
    }
}

Write-Host "Reachable IP pairs:"
Write-Host $init_targ_pair

foreach ( $this_pair in $init_targ_pair ) {
    $addrs = $this_pair.Split(',')
    New-IscsiTargetPortal -TargetPortalAddress $addrs[1] -InitiatorPortalAddress $addrs[0]
    Get-IscsiTarget | Connect-IscsiTarget -IsPersistent $true -IsMultipathEnabled $true -AuthenticationType NONE -TargetPortalAddress $addrs[1] -InitiatorPortalAddress $addrs[0]
}

Update-HostStorageCache
