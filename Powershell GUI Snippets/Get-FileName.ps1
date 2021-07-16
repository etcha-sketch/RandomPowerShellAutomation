# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

Function Get-FileName {
    param(
    $WindowTitle = "Select a file",
    $FileFilter = "All Files|*.*"
    )

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Filter = $FileFilter
	$OpenFileDialog.Title = $WindowTitle
	$show = $OpenFileDialog.ShowDialog()

    If ($Show -eq "OK") {
        Return $OpenFileDialog.FileName
    }
    Else {
        Write-Error "Operation cancelled by user."
	}
}
