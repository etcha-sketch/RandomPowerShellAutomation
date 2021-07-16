# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

Push-Location "C:\windows\system32"
$installedupdates = wmic qfe get hotfixid

$installedupdates = $installedupdates | Where ({$_ -ne ""})

$installedkbs = @()
foreach ($update in $installedupdates)
{
	$installedkbs = $installedkbs + (($update.split('B'))[1])

}

[array]::Reverse($installedkbs)

$totalcount = $installedkbs.Count
$working = 1
Clear-Host
Write-Host "`n`n`n`n`n`n`n`n"

Write-host '---------------------------------------------------------------------------------------------' -forgroundcolor yellow
write-host 'PRESS C AT ANY TIME TO PAUSE AFTER THE CURRENT UNINSTALL FINISHES'
Write-host '---------------------------------------------------------------------------------------------' -forgroundcolor yellow


foreach ($installedkb in $installedkbs)
{
	if (($installedkb -ne $null) -and ($installedkb -ne ""))
	{
		$installedkb = $installedkb.Trim()
		Write-host "`nProcessing KB$($installedkb)"
		Write-Progress -Activity 'Uninstalling Windows Updates' -CurrentOperation "Removing KB$($installedkb)" -PercentComplete (($working/$totalcount)*100) -Status "$($working)/$($totalcount)"
		$args = @("/uninstall","/kb:$($installedkb)","/quiet","/norestart")
		Write-host "Running command: wusa $($args)"
		Start-Process wusa.exe -ArgumentList $args -Wait
		$working += 1
		Start-Sleep -Milliseconds 50
	}
	if ([Console]::KeyAvailable)
	{
		$key = [Console]::ReadKey($true)
		if ($key.key -eq 'c')
		{
			Write-host '"C" Key Pressed. Pausing'
			pause
		}
	}

}
Pop-Location
