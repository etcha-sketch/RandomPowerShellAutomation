# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function Apply-VMHardeningSetting
{
    [cmdletbinding()]
    param(
        [parameter(mandatory=$false)]
        $VMName,
        [parameter(mandatory=$true)]
        $value,
		[parameter(mandatory=$true)]
        $name,
		[Switch]$AllVMs
        )

	if ($AllVMs)
	{
		$allvms = Get-VM
		foreach ($vm in $allvms.name)
		{
			$currentstate = Get-VM $vm | Get-AdvancedSetting -Name $name
			if ($currentstate.value -ne $value)
			{
				Write-host "$($vm) does not meet requirement, correcting." -ForegroundColor Red
				Get-VM $vm | New-AdvancedSetting -Name $name -Value $value -Confirm:$false -Force
	
			}
			else
			{
				Write-host "$($vm) - $($name) already meets requirement." -ForegroundColor Green
			}
	
		}
	}
	else
	{
		$vm = Get-VM -Name $VMName
		
		$currentstate = Get-VM $vm | Get-AdvancedSetting -Name $name
		if ($currentstate.value -ne $value)
		{
			Write-host "$($vm) does not meet requirement, correcting." -ForegroundColor Red
			Get-VM $vm | New-AdvancedSetting -Name $name -Value $value -Confirm:$false -Force
	    
		}
		else
		{
			Write-host "$($vm) - $($name) already meets requirement." -ForegroundColor Green
		}
	    
		
	
	}
}

Apply-VMHardeningSetting -AllVMs -Name isolation.tools.copy.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.dnd.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.setGUIOptions.enable -Value false
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.paste.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.diskShrink.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.diskWiper.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.hgfsServerSet.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.ghi.autologon.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.ghi.launchmenu.change -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.memSchedFakeSampleStats.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.ghi.protocolhandler.info.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.ghi.host.shellAction.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.ghi.trayicon.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.unity.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.unityInterlockOperation.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.unity.push.update.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.unity.taskbar.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.unityActive.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.unity.windowContents.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.vmxDnDVersionGet.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name isolation.tools.guestDnDVersionSet.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name RemoteDisplay.maxConnections -Value 1
Apply-VMHardeningSetting -AllVMs -Name RemoteDisplay.vnc.enabled -Value false
Apply-VMHardeningSetting -AllVMs -Name tools.setinfo.sizeLimit -Value 1048576
Apply-VMHardeningSetting -AllVMs -Name isolation.device.connectable.disable -Value true
Apply-VMHardeningSetting -AllVMs -Name tools.guestlib.enableHostInfo -Value false
Apply-VMHardeningSetting -AllVMs -Name tools.guest.desktop.autolock -Value true
Apply-VMHardeningSetting -AllVMs -Name mks.enable3d -Value false
Apply-VMHardeningSetting -AllVMs -Name tools.guest.desktop.autolock -Value true
Apply-VMHardeningSetting -AllVMs -Name mks.enable3d -Value false

Get-VM | Get-AdvancedSetting -Name sched.mem.pshare.salt | Remove-AdvancedSetting
