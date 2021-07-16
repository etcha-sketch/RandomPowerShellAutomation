# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

$allservers = (Get-ADComputer -Filter * -Properties * | Where OperatingSystem -Like "*Server*").Name
$offlineservers = @()
foreach ($RemoteComputer in $allservers)
{
    Write-host "`n`nTesting connection to $($RemoteComputer)"
    
    if (((Test-NetConnection -ComputerName $RemoteComputer -ErrorAction SilentlyContinue).pingsucceeded) -eq "True")
    {
        Write-host "$($RemoteComputer) is online, sending command now"
        Invoke-command -computer $RemoteComputer -ScriptBlock {
        Uninstall-WindowsFeature -Name PowerShell-v2
        Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
        }
        
    }
    else
    {
        Write-host "$($RemoteComputer) is offline" -ForegroundColor Red
        $offlineservers = $offlineservers + "$($RemoteComputer)"
    }
}

if ($offlineservers.Count -ne 0)
{
    foreach ($offlineserver in $offlineservers)
    {
        Write-host "$($offlineserver) was offline." -ForegroundColor Red
    }
}
