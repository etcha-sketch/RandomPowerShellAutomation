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

Set-windowsize 36 4

Get-CimInstance -Class Win32_LogicalDisk -ComputerName ((Get-ADComputer -Filter * -Properties * |`
     Where OperatingSystem -Like "*Server*" | Select-Object Name, OperatingSystem).Name) | Where-Object DriveType -EQ '3' |`
     Select-Object  @{Name="Hostname";Expression={$_.SystemName}}, @{Name="Drive Root";Expression={"$($_.DeviceID)\"}},`
	 @{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}},`
     @{Name="Free Space(GB)";Expression={($_.freespace/1gb).ToString('N2')}}, @{Name="Size(GB)";Expression={(($_.size/1gb).ToString('N2'))}} |`
     Sort-Object "Free (%)"  | Out-GridView -Title "Server Free Space" -Wait
