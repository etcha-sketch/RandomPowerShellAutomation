# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# Dumps all of your VMs, NIC type, and MAC Address.
Clear-host
Write-Host "You need to run this script with PowerCLI modules loaded, this will not function in standard powershell,"
Write-Host "exit this window if you have not loaded the PowerCLI modules."
Pause
Clear-host
Write-Host "This will create a file on your desktop named VM-Info.txt with the following information"
Write-Host "Name, PowerState, AdapterType, MAC Type, Type."
Write-Host "Login with your username (xxxxxx@domain.com)"
Pause
$Desktoppath = [Environment]::GetFolderPath("Desktop")
Connect-VIServer <x.x.x.x>
Get-VM|Select-Object -Property Name, PowerState, @{"Name"="Adapter";"Expression"={($_ | Get-NetworkAdapter).Type}}, @{"Name"="Type";"Expression"={($_ | Get-NetworkAdapter).ExtensionData.AddressType}}, @{"Name"="MAC";"Expression"={($_ | Get-NetworkAdapter).MacAddress}} | Out-String -Width 4096 | Out-File $Desktoppath\VM-Info.txt
