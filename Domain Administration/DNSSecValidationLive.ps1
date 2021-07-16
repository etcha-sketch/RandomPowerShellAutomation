# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function Get-TimeStamp
{
    return "[{0:MM/dd/yyyy} {0:HH:mm:ss}]" -f (Get-Date)
}


$pshost = Get-Host
$pswindow = $pshost.UI.RawUI
$newsize = $pswindow.BufferSize

$newsize.Height = 5
$newsize.Width = 40

$pswindow.WindowSize=$newsize

# Verify DNSSec is functioning on the following DNS Servers.
$dnsservers = "10.10.10.10","10.10.10.11","10.10.10.12"

while ($true)
{
	Clear-Host
	Write-host "$(Get-TimeStamp) DNSSEC VALIDATION" -ForegroundColor Gray
	
	foreach ($server in $dnsservers)
	{
		# You must create a static A record in your domain called dnssectest.domain.com with a static ip of 99.99.99.99
		#        You can adjust the fqdn and IP to suit your needs. Make sure the record is in a signed zone.
		$output = Resolve-DnsName dnssectest.domain.com -Server $server -NoRecursion -NoHostsFile -DnssecOk RRSIG -DnsOnly
		$ipverification = Resolve-DnsName dnssectest.domain.com -Server $server
		
		$output = $output[0]
		
		if (($output.Type -ne 'RRSIG') -or ($output.Signer -ne 'domain.com') -or ($ipverification[0].IPAddress -ne '99.99.99.99') -or ($output.Signed -lt ((Get-date).AddDays(-10.1))))
		{
				Write-host "$($server) DNSSEC Failed" -ForegroundColor Red
		}
		else
		{
				Write-host "$($server) DNSSEC Functioning" -ForegroundColor Green
		}
	}
	Start-Sleep -Seconds 5
}
