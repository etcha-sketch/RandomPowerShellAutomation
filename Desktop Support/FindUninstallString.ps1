# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# Provide a single search term like 'chrome' or 'acrobat' to find the msi guid for uninstall.
$searchstring = Read-host "What application are you looking for the uninstall string for"

$allsub = Get-childitem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' | Where Name -like "*{*}"
$allsub += Get-childitem 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall' | Where Name -like "*{*}"
foreach ($sub in $allsub)
{

    $reg = (Get-ItemProperty $sub.Name.Replace('HKEY_LOCAL_MACHINE','HKLM:'))

    if (($reg.DisplayName -ne $null) -and ($reg.UninstallString -ne $null))
    {
        if ($reg.displayName -like "*$($searchstring)*")
        {
        
        Write-host "$($reg.DisplayName)`n     $($reg.PSPath.ToString().replace('Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE','HKLM'))`n     $($reg.UninstallString)"
        }
    }
    
    Clear-Variable reg
}
