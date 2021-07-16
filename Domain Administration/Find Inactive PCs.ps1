# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# Finds all PCs under an OU called Departments in the root of the domain.com domain which haven't
# been online for greater than 30 days. Adjust for your environment.
$allpcs = Get-ADComputer -Filter * -Properties * | Where CanonicalName -like "domain.com/Departments/*"

$inactivepcs = @()

foreach ($pc in $allpcs)
{
    if ($pc.LastLogonDate -le ((Get-date).AddDays(-30)))
    {
        Write-host "$($pc.DNSHostName): $($pc.Description) - $(($pc.LastLogonDate).ToString("yyyy-MM-dd"))"
        $inactivepcs += $pc
    }

}
