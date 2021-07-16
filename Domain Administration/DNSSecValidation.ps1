# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

Clear-Host
function Get-TimeStamp
{
    return "[{0:MM/dd/yyyy} {0:HH:mm:ss}]" -f (Get-Date)
}
$date = (get-date -Format "yyyy-MM-dd").ToString()
$sendfailure = 0
$erroralert = "adminDistroList@domain.com","NOCSupervisor@domain.com"
$fromalert = "DNSSec.alerts@domain.com"
$subject = "$(get-date -Format 'yyyy-MM-dd HH:mm') DNSSEC Failure"
$body = "Dear admin,`n`nA problem has been found with DNSSEC Validation, please see below for specifics:`n`n"

$log = "\\fileserver.domain.com\autologs$\DNSSEC_Logs\$($date)-DNSSEC.LOG"


# Verify DNSSec is functioning on the following DNS Servers.
$dnsservers = "10.10.10.10","10.10.10.11","10.10.10.12"


foreach ($server in $dnsservers)
{
	# You must create a static A record in your domain called dnssectest.domain.com with a static ip of 99.99.99.99
	#        You can adjust the fqdn and IP to suit your needs.
	$output = Resolve-DnsName dnssectest.domain.com -Server $server -NoRecursion -NoHostsFile -DnssecOk RRSIG -DnsOnly
	$ipverification = Resolve-DnsName dnssectest.domain.com -Server $server
	
	$output = $output[0]
	
	if (($output.Type -ne 'RRSIG') -or ($output.Signer -ne 'domain.com') -or ($ipverification[0].IPAddress -ne '99.99.99.99') -or ($output.Signed -lt ((Get-date).AddDays(-10.1))))
	{
		Write-output "$(Get-TimeStamp) $server DNSSEC failed, sending e-mail alert now." | Out-File $log -Append
		$body += "$server DNSSEC validation failed.`n"
		$sendfailure = $true
	}
	else
	{
		$sendfailure = $false
		Write-output "$(Get-TimeStamp) $server DNSSEC functioning." | Out-File $log -Append
	}
	
	Clear-Variable output
	Clear-Variable ipverification
	
}

$body += "`n`n`nThe full log can be found at \\fileserver.domain.com\autologs$\DNSSEC_Logs\$($date)-DNSSEC.LOG"
$body += "`n`nSincerely,`nNOC Admin Team`n`nAuto-alert generated at $(Get-date -format 'HH:mm') on $(Get-date -format 'yyyy-MM-dd')"


if ($sendfailure)
{
	Send-MailMessage -from $fromalert -To $erroralert -Subject $subject -Body $body -Priority High -SmtpServer 'exchange.domain.com' -Port '25'
	$sendfailure = $false
}

clear-variable body

# Configure the .AddDays(x) to automatically clean up old logs older then x days.
set-location -Path "\\fileserver.domain.com\autologs$\DNSSEC_Logs\"
Get-ChildItem  *.log -recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-366))} | Remove-Item -Force
