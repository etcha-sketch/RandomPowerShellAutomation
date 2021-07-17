  
# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# Disables and re-enables the Ethernet NIC.
# When remotely supporting a user, if you try to disable the NIC remotely you will lose connection.
# This will cause you to lose connection, but it should reconnect after a few seconds when the NIC
# is automatically re-enabled.

Get-NetAdapter -Name Ethernet | Disable-NetAdapter -Confirm:$false; start-sleep -seconds 5; Get-NetAdapter -Name Ethernet | Enable-NetAdapter -Confirm:$false
