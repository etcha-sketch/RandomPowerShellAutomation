# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function Get-ShortTimeStamp
{
    return "[{0:HH:mm:ss}]" -f (Get-Date)
}


Function Set-WindowSize {
Param([int]$x=$host.ui.rawui.windowsize.width,
      [int]$y=$host.ui.rawui.windowsize.height)

      $size=New-Object System.Management.Automation.Host.Size($x,$y)
      $host.ui.RawUI.WindowSize=$size
}

function OU-Status
{
	
    $host.UI.RawUI.WindowTitle="Device Up/Down Status"
    clear-host
    
	# OU like "OU=Departments,DC=domain,DC=com"
    [string]$ou = Read-host "What is the OU?"
    [int]$sleeptime = Read-Host "How long to sleep between cycles? (in seconds)"
	# Finds all Windows 10 PCs in the OU. Change the where statement to include other OSs
    $allpcinou = (Get-ADComputer -Filter * -SearchBase $ou -Properties *  | Select-Object Name, OperatingSystem | Where OperatingSystem -Like "*10*").Name


    $allservers = [ordered]@{}
    foreach ($device in $allpcinou)
    {
        
        $ip = (Resolve-DnsName -Name $device -ErrorAction SilentlyContinue | Where Type -EQ "A" ).IPAddress
        if (($ip -ne $null))
            {
            $allservers[$device] = $ip
            }
        Clear-Variable ip
    }


	
    

    
    #              W  H
    Set-WindowSize 77 $($allservers.Count + 3)
		
	foreach ($server in $allservers.Keys)
    {
		New-Variable -Name "$($server)-dropped" -Value 0
    }



    while ($true)
	{
		clear-host
		write-host " "
		write-host "$(Get-ShortTimeStamp)"-ForegroundColor Gray
		foreach ($server in $allservers.Keys)
		{
			$servername = $server #"$($server)" + "." + "$($userdomain)"
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
                }
			else
				{
				    Set-Variable -Name "$($server)-dropped" -Value ((Get-Variable -Name "$($server)-dropped" -ValueOnly) + 1)
					Write-Host "$($server) [$($allservers[$($server)])] is down. DroppedPings=$(Get-Variable -Name "$($server)-dropped" -ValueOnly)" -ForegroundColor DarkRed
					$host.UI.RawUI.WindowTitle="*Device Up/Down Status"
                }
	
	
	
		}
		Start-Sleep -Seconds $sleeptime
			
	}
}

OU-Status
