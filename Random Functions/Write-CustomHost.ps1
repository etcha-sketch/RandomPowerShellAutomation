# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function Get-LongTimeStamp
{
    return "[{0:MM/dd/yyyy} {0:HH:mm:ss}]  " -f (Get-Date)
}

function Write-CustomHost
{
param([string]$Content="No Content Specified",
    [string]$ForegroundColor="White",
    [array]$OutFiles="$($env:USERPROFILE)\Desktop\$(Get-date -format "yyyy-MM-dd")_Log.log",
    [switch]$NoLog,
    [switch]$TimeStamp=$false
    )

    Write-host $content -ForegroundColor $foregroundcolor

    $content = $content -replace "`n"," "
    #Write-output $l
    if (!$NoLog)
    {
        if (!$TimeStamp)
        {
            foreach ($f in $OutFiles)
            {
                Write-Output $content | Out-file $f -Append
            }
        }
        else
        {
            foreach ($f in $OutFiles)
            {
                Write-Output "$(Get-LongTimeStamp) $($content)" | Out-file $f -Append
            }
        }
    }
}
