# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# This just disconnects and reconnects a VM's NIC (all of them if there are multiple).
# you must have PowerCLI started, loaded, and connected before running this.
function Reset-VMNetAdapter
{
    param([string]$ProblemVM)
    
    if ($ProblemVM -eq "")
    {
        $badvm = read-host "What VM?"
    }
    else
    {
        $badvm = $ProblemVM
    }

    Write-host "`nResetting network adapters on $($badvm)`n"
    
    foreach ($net in (Get-NetworkAdapter -vm (get-vm -Name $badvm)))
    {
      $net | Set-NetworkAdapter -Connected $false -Confirm:$false
    
    }
    
    Start-Sleep -seconds 10
    
    foreach ($net in (Get-NetworkAdapter -vm (get-vm -Name $badvm)))
    {
    $net | Set-NetworkAdapter -Connected $true -Confirm:$false
    
    }
}
