# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

Function Set-WindowsSize {
Param([int]$x=$host.ui.rawui.windowsize.width,
      [int]$y=$host.ui.rawui.windowsize.height)


      $size=New-Object System.Management.Automation.Host.Size($x,$y)
      $host.ui.RawUI.WindowSize=$size

}

Set-WindowsSize 36 4
clear-host
echo "Keep-alive"
$i=0
$wshell = New-Object -ComObject "Wscript.Shell"

while ($true)
{
    $i++
    clear-host
    write-host "Keep-alive iteration $i"
    $wshell.SendKeys("{SCROLLLOCK}")
    write-host "Sent scroll lock sleeping 100ms"
    Start-Sleep -Milliseconds 100
    $wshell.SendKeys("{SCROLLLOCK}")
    write-host "Sent scroll lock sleeping 240s"
    Start-Sleep -Seconds 240
}
