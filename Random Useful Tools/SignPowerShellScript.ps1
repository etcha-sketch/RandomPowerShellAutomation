# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

$global:mypscert = "Cert:\CurrentUser\My\XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
function Sign-Script
{
	$mypscert = Get-ChildItem $global:mypscert
	$filetosign = Read-Host "Path to script to sign"
	if (Test-Path ($filetosign.Replace('"','')))
	{
		$filesign = Get-Item -Path ($filetosign.Replace('"',''))
		
		# Remove old Signature and Old Date Information
	   
		$content = Get-content $filesign
		$newcontent = @()
		$eof = $false
		foreach ($l in $content)
		{
			if (!($eof))
			{
				if ($l -inotlike "#Script Signed*")
				{
					if ($l -inotlike "# SIG # Begin*")
					{
						$newcontent += $l
					}
					else {$eof = $true}
				}
				else {$eof = $true}
			}
		}           
		$newcontent | Set-Content -Path $filesign
		
		if (!($eof))
		{
			Write-output " " | Out-file $filesign -Append utf8
		}
		Write-output "#Script Signed $(get-date -format "yyyy-MM-dd HH:mm") by $($env:USERDOMAIN)\$($env:USERNAME)" | Out-file $filesign -Append utf8
		Write-Output "#Script signature expires $('{0:yyyy-MM-dd HH:mm}' -f $mypscert.NotAfter)" | Out-file $filesign -Append utf8
								
		Set-AuthenticodeSignature -Certificate $mypscert -FilePath $filesign | Out-Null
		Start-Sleep -Milliseconds 200
		$goodsign = Get-AuthenticodeSignature -FilePath $filesign
		if (($goodsign.Status -eq 'Valid') -and ($goodsign.SignerCertificate.Thumbprint -eq ((($global:mypscert).Split('\'))[-1])))
		{
			Write-host "`nScript Signed Successfully" -ForegroundColor Green
			Write-host "Script signature expires $('{0:yyyy-MM-dd HH:mm}' -f $mypscert.NotAfter)`n`n" -ForegroundColor Gray
		}
		else
		{
			Write-host "`nScript signature failed!" -ForegroundColor Red
		}
	}
	else
	{
		Write-host "Cannot Find File" -foregroundcolor Red
	}
}
