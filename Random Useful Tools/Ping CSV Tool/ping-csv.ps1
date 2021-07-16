# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

Function Set-WindowSize {
Param([int]$x=$host.ui.rawui.windowsize.width,
      [int]$y=$host.ui.rawui.windowsize.height)

      $size=New-Object System.Management.Automation.Host.Size($x,$y)
      $host.ui.RawUI.WindowSize=$size
}


function Get-ShortTimeStamp
{
    return "[{0:HH:mm:ss}]" -f (Get-Date)
}

Function Get-FileName 
{
	param([string]$Filemask="All Files|*.*")
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Filter = $Filemask
    $OpenFileDialog.Title = 'Select File to Open'
    $show = $OpenFileDialog.ShowDialog()

    If ($Show -eq "OK") {
        Return $OpenFileDialog.FileName
    }
    Else {
        Write-Error "Operation cancelled by user."
    }
}

	
    $host.UI.RawUI.WindowTitle="Device Up/Down Status"
    clear-host
    $filename = Get-FileName -Filemask 'CSV File|*.csv'
    $import = Import-Csv $filename
    [int]$sleeptime = Read-Host "How long to sleep in seconds between cycles?"
	$allservers = [ordered]@{}
    foreach ($device in $import)
    {
        $allservers[$device.Name] = $device.IP
    }
	    
    #              W  H
    Set-WindowSize 80 ($($allservers.Count + 3)*3)
		
	foreach ($server in $allservers.keys)
    {
		New-Variable -Name "$($server)-lastseen" -Value "NEVER"
		New-Variable -Name "$($server)-dropped" -Value 0
    }

	$loopcount = 1

    while ($true)
	{
		if ([Console]::KeyAvailable)
		{
			$key = [Console]::ReadKey($true)
			if ($key.key -eq 'c')
			{
				foreach ($server in $allservers.Keys)
				{
					Set-Variable -Name "$($server)-dropped" -Value 0
					#Set-Variable -Name "$($server)-lastseen" -Value "NEVER"
				}
				$host.UI.RawUI.WindowTitle="Device Up/Down Status"
			}
		}
		
		if ($loopcount -eq 3)
		{
			start-sleep -milliseconds 500
			clear-host
			$loopcount = 0
		}
		$loopcount = $loopcount + 1
		write-host " "
		write-host "$(Get-ShortTimeStamp)"-ForegroundColor Gray
		foreach ($server in $allservers.Keys)
		{
			$servername = $allservers[$($server)] #"$($server)" + "." + "$($userdomain)"
			$output = Test-Connection $servername -BufferSize 32 -Count 1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			if ($output -ne $null)
				{
				    if ((Get-Variable -Name "$($server)-dropped" -ValueOnly) -eq 0)
                    {
                        Write-host "$($server) [$($allservers[$($server)])] is up, time=$($output.ResponseTime)ms TTL=$($output.ResponseTimeToLive)" -ForegroundColor Green
        		    }
                    else
                    {
                        Write-host "$($server) [$($allservers[$($server)])] is up, time=$($output.ResponseTime)ms TTL=$($output.ResponseTimeToLive) DroppedPings=$(Get-Variable -Name "$($server)-dropped" -ValueOnly)" -ForegroundColor DarkCyan
                    }		
                Set-Variable -Name "$($server)-lastseen" -Value "$(get-date -Format 'yyyy-MM-dd HH:mm:ss')"
                }
			else
				{
				    Set-Variable -Name "$($server)-dropped" -Value ((Get-Variable -Name "$($server)-dropped" -ValueOnly) + 1)
					Write-Host "$($server) [$($allservers[$($server)])] is down. DroppedPings=$(Get-Variable -Name "$($server)-dropped" -ValueOnly) LastSeen=$(Get-Variable -Name "$($server)-lastseen" -ValueOnly)" -ForegroundColor DarkRed
					$host.UI.RawUI.WindowTitle="*Device Up/Down Status"
                }
	
	
	
		}
		Start-Sleep -Seconds $sleeptime
			
	}
