# github.com/etcha-sketch
# 03/6/2022
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# VARIABLE DECLARATIONS
$Script:CompanyName = 'Test Company'
$Script:ScriptName = 'Demo Script'
$Script:ScriptVersion = '0.1'
$Script:RegPath = "HKCU:\SOFTWARE\ScriptAutomation\$($Script:CompanyName)\Logon\$($Script:ScriptName)"
$Script:LogPath = "$($env:LOCALAPPDATA)\ScriptAutomation\$($Script:CompanyName)\Startup\$($Script:ScriptName)_$(Get-Date -format 'yyyy-MM-dd').log"
# END VARIABLE DECLARATIONS

# DEBUG
$Script:VerboseLog = $false
# $Script:LogFileExists = $false
# Clear-Content "$($env:LOCALAPPDATA)\ScriptAutomation\$($Script:CompanyName)\Logon\$($Script:ScriptName)_$(Get-Date -format 'yyyy-MM-dd').log"
# END DEBUG

function Write-Log
{
    param(
    [string]$Object = 'Some Information'
    )
    if (!($Script:LogFileExists))
    {
        if (Test-path $Script:LogPath)
        {
            $Script:LogFileExists = $true
        }
        else
        {
            New-item -ItemType File -Path $Script:LogPath -Force | Out-Null
            $Script:LogFileExists = $true
        }
    }
    Write-Output "[$(Get-date -Format 'yyyy-MM-dd HH:mm:ss')]  $($Object)" | Out-File -FilePath $Script:LogPath -Encoding utf8 -Append
}

function Setup-ScriptRegUser
{
    if ($Script:VerboseLog) { Write-Log "Setting Up Registry Paths" }
    $GenPath = ''
	$Script:RegPath = ($Script:RegPath).Replace('/','\')
    Foreach ($Hive in ((($Script:RegPath).Split('\')))| Where {$_ -ne ''})
    {
        $GenPath += ((($Hive).Replace('\','')) + '\')
        if (Test-path $GenPath)
        {
            if ($Script:VerboseLog) { Write-Log "    $($GenPath) already exists." }
        }
        else
        {
            if ($Script:VerboseLog) { Write-Log "    $($GenPath) does not exist, creating now." }
            New-Item -ItemType Directory -Path $GenPath | Out-Null
        }
    }
    Write-ScriptRegUser -KeyName LastVersion -Value $Script:ScriptVersion
}

function Write-ScriptRegUser
{
    param(
        [string]$KeyName = 'Demo Key',
        $Value = 1
    )
    New-ItemProperty -Path $Script:RegPath -Name $KeyName -Value $Value -Force | Out-Null
}

function Get-ScriptRegUser
{
    param(
        [string]$KeyName = 'Demo Key'
    )
    $r = Get-ItemPropertyValue -Path $Script:RegPath -Name $KeyName
    Return $r
}

Write-Log "$('='*40)"
Write-Log "STARTING $($Script:ScriptName) v$($Script:ScriptVersion)"
Write-Log "$('='*40)"
if (($Script:VerboseLog) -and (!(Test-path $Script:RegPath)))
{
    Write-Log "First Run Detected!"
}
if (($Script:VerboseLog) -and (Test-path $Script:RegPath))
{
    Write-Log "Last Run Detected: $([datetime](Get-ScriptRegUser -KeyName LastRun))"
    Write-Log "Last Ran Version: $((Get-ScriptRegUser -KeyName LastVersion))"
}
Setup-ScriptRegUser

# Put Custom Code Here



# End Custom Code

Write-ScriptRegUser -KeyName LastRun -Value "$(get-date)"
Write-Log "Script Complete"