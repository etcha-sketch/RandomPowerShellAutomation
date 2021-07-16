# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

#Set-Location \\fileserver.domain.com\
#Get-childitem -Recurse | Where-Object {(($_.LastWriteTime.Date -le (Get-Date).Date.AddDays(-30)))
$yesterday = (Get-Date (Get-Date).AddDays(-1) -UFormat %y%M%d)
$logdate = ([string]((Get-Date).AddDays(-1).DayOfWeek)).Substring(0,3)
$thedate = get-date -date $(get-date).adddays(-1) -format yyyy-MM-dd

#DHCP001 Log Backups
Set-Location "C:\Windows\System32\dhcp"
Copy-Item "DhcpSrvLog-$logdate.log" "\\fileserver.domain.com\DHCPlogs$\DHCP001"
Copy-Item "Dhcpv6SrvLog-$logdate.log" "\\fileserver.domain.com\DHCPlogs$\DHCP001"
Set-Location "\\fileserver.domain.com\DHCPlogs$\DHCP001"
Rename-Item "DhcpSrvLog-$logdate.log" "$thedate-DHCP.log"
Rename-Item "Dhcpv6SrvLog-$logdate.log" "$thedate-DHCPv6.log"

Set-Location "C:\Windows\System32\dhcp"
Get-ChildItem *.log -recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-35))} | Remove-Item -Force
