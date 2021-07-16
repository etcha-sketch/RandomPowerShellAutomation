# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

$AllowedHosts = @("10.10.10.3","10.10.10.4","10.10.10.5","10.10.10.6","10.10.10.7","10.10.10.8","10.10.10.9","10.10.13.0","10.10.11.3","10.10.11.4","10.10.11.5","10.10.11.6","10.10.11.7","10.10.11.8","10.10.11.9","10.10.12.0","10.10.13.9")

foreach ($AllowedHost in $AllowedHosts)
{
    Grant-NfsSharePermission -Name <FileShareName> -ClientName $AllowedHost -ClientType host -Permission readwrite -AllowRootAccess:$true
}
