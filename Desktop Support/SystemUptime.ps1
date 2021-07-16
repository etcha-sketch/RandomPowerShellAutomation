# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

[datetime]$startup = (gcim Win32_OperatingSystem).LastBootUpTime
[datetime]$currenttime = Get-Date

$uptime = $currenttime - $startup

Write-host "`nSystem Uptime: " -ForegroundColor Gray -NoNewline
Write-host "$($uptime.Days) Days $($uptime.Hours) Hours $($uptime.Minutes) Min $($uptime.Seconds) Seconds`n" -ForegroundColor Green
