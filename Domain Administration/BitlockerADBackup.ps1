# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# Set to run as a startup script in a domain where Bitlocker was previously enabled, but AD backup was not enabled at that time.

$drives = get-psdrive | Where Free -gt 0
$localdrives = @()
foreach ($drive in $drives) {
    if ($drive.Provider.Name -eq 'FileSystem') {
        $localdrives += $drive
    }
}

foreach ($localdrive in $localdrives) {
    $output = manage-bde -protectors -get $(($localdrive.Root).Replace('\',''))
    if ($output -like "*ERROR:*") {
        # Drive is not encrypted
    } elseif ($output -like "*Numerical Password*") {
        # Drive is bitlocker encrypted
        manage-bde -protectors -adbackup $(($localdrive.Root).Replace('\','')) -id "$(((((($output | Select-String "ID")[0]).ToString()).Split(':'))[1]).Trim())"
    } else {}
}
