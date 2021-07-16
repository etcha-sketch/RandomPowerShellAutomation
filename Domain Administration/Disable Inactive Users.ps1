# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function Find-InactiveUsers
{
    param(
    [int]$DaysInactive = 35,
    [int]$DaysSinceCreation = 14,
    [switch]$AutomaticallyDisableAllInactive,
    [switch]$JustInformational
    )
    $inactiveflag = $false
    $disablestring = "Account automatically disabled on $(get-date -format 'yyyyMMdd') due to inactivity."

    $allusers = Get-ADUser -Filter * -Properties * -SearchBase "OU=Departments,DC=domain,DC=com" | Where Name -Like "*,*.*" | Where Enabled -ne $false
	# Finds all users in the Departments OU with a Name formatted like "Last, First I."
    
    foreach ($user in $allusers)
    {
        if ($user.LastLogonDate -eq $null)
        {
            
            $created = New-timespan -Start $user.Created
            if ($created.Days -gt $dayssincecreation)
            {
                Write-host "$($user.Name) created $($created.Days) days ago but has not logged in. [Created: $($user.Created)]" -ForegroundColor Red
                $inactiveflag = $true
            }
            else
            {
                $acctdayssincecreation = $(((get-date) - ($user.Created)))
                $inactiveflag = $true
                Write-host "[WARNING] $($user.Name) has never logged in. [$($acctdayssincecreation.days) days since creation] [Created: $($user.Created)]" -ForegroundColor Yellow
            }
    
    
        }
        else
        {
            $lastlogon = New-timespan -Start $user.LastLogonDate
            if ($lastlogon.Days -gt $daysinactive)
            {
                $inactiveflag = $true
                Write-host "$($user.Name) last logged on $($lastlogon.Days) days ago." -ForegroundColor Red

                if (!$AutomaticallyDisableAllInactive)
                {
                    $query = "n"
                    $todisable = $false
                    if (!$JustInformational)
                    {

                        $query = Read-host "     Do you want to disable $($user.Name) y/[n]"
                        if ($query.ToLower() -eq "y") 
                        {
                            $todisable = $true
                        }
                        else
                        {
                            Write-host "     Not disabling $($user.name)"
                        }
                    }
                    else
                    {
                        $todisable = $false
                    }
                }

                else
                {
                    Write-host "     Disabling $($user.Name)"
                    $todisable = $true
                }

                if ($todisable)
                {
                    Disable-ADAccount $user
                    set-aduser $user -Description $disablestring
                }


    
            }
            elseif ($lastlogon.Days -gt ($DaysInactive-7))
            {
                $inactiveflag = $true
                Write-host "[WARNING] $($user.Name) last logged on $($lastlogon.Days) days ago." -ForegroundColor Yellow
            }
        }
    
    }

    if (!$inactiveflag)
    {
        Write-host "No inactive accounts found with specified parameters"
    }

}

# Example:
Find-InactiveUsers -DaysInactive 60 -DaysSinceCreation 14 -AutomaticallyDisableAllInactive
