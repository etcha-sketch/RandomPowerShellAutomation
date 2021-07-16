# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# Used to Create a Shortcut with Windows PowerShell
$TargetExe = "$env:SystemRoot\System32\notepad.exe"
$ShortcutFilePath = "$env:Public\Desktop\Notepad.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFilePath)
$Shortcut.TargetPath = $TargetExe
$Shortcut.Save()
