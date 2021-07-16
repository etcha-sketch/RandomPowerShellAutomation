# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

clear-host

$servers = ((Get-ADComputer -Filter * -Properties * | Where OperatingSystem -Like "*Server*" | Select-Object Name, OperatingSystem).Name)
$i = 0

clear-host

foreach ($server in $servers)
{


$process = gwmi win32_process -ComputerName $server -f 'Name = "explorer.exe"'
$processid = $process |% ProcessId
$loggedon = $process|% getowner|% user
$attime = $process|% CreationDate

    if ($loggedon -ne $null)
    {
       
       $y=0
       $totalcount = 0
       Write-host $server        
       foreach ($user in $loggedon)
       {
            $totalcount = $loggedon.count
            
            if ($totalcount -eq 1)
            {
				write-host "$($user) logged in since $(($attime).split('.')[0])"
            }
            else
            {
				write-host "$($user) logged in since $((($attime[$y]).split('.'))[0])"
            }
            
            $y++
            $i++
       }
    write-host `n`n`
    }
}
Write-host "There are $i sessions on servers"
