# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# PowerShell script to download all McAfee updates on https://www.mcafee.com/enterprise/en-us/downloads/security-updates.html

clear-host
write-host "`n`n`n`n`n"
$currentxdat = ""
$currentxdatepo = ""
$currentmeddat = ""
$currentinteng = ""
$currentv3dat = ""
$fileoutput = "$($env:USERPROFILE)\Downloads\McAfeeDownloads"
if (!(test-path $fileoutput))
{
    Write-host "New Downloads will be downloaded to: $($env:USERPROFILE)\Downloads\McAfeeDownloads" -ForegroundColor Green
	New-item -ItemType directory -Path $fileoutput | Out-Null
}
else
{
    Write-host "New Downloads will be downloaded to: $($env:USERPROFILE)\Downloads\McAfeeDownloads" -ForegroundColor Green
	$currentitems = gci "$($fileoutput)"
    if ($currentitems.count -gt 0)
    {
        Push-location $fileoutput
        if (((gci "*xdat.exe" -ErrorAction SilentlyContinue | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue ).count) -gt 0)
        {
            $currentxdat = (gci "*xdat.exe" -ErrorAction SilentlyContinue | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue )[0].Name
        }
        if (((gci "avvepo*.zip" -ErrorAction SilentlyContinue  | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue ).count) -gt 0)
        {
            $currentxdatepo = (gci "avvepo*.zip" -ErrorAction SilentlyContinue  | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue )[0].Name
        }
        if (((gci "mediumepo*.zip" -ErrorAction SilentlyContinue  | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue ).count) -gt 0)
        {
            $currentmeddat = (gci "mediumepo*.zip" -ErrorAction SilentlyContinue  | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue )[0].Name
        }
        if (((gci "epo*eng.zip" -ErrorAction SilentlyContinue  | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue ).count) -gt 0)
        {
            $currentinteng = (gci "epo*eng.zip" -ErrorAction SilentlyContinue  | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue )[0].Name
        }
        if (((gci "epoV3*.zip" -ErrorAction SilentlyContinue  | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue ).count) -gt 0)
        {
            $currentv3dat = (gci "epoV3*.zip" -ErrorAction SilentlyContinue  | Sort-Object -Property LastWriteTime -Descending -ErrorAction SilentlyContinue )[0].Name
        }
        Pop-Location
    }
}


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
while ($true)
{
    $change = $false
    $webpage = (Invoke-WebRequest -UseBasicParsing -Uri "https://www.mcafee.com/enterprise/en-us/downloads/security-updates.html" -ErrorAction SilentlyContinue ).Content
    $alllinks = @()
    
    foreach ($l in ($webpage.Split([Environment]::NewLine)))
    {
        if (($l -like "*href*exe*ePO*") -or ($l -like "*href*zip*ePO*") -or ($l -like "*href*english*exe*") -or ($l -like "*href*epoV3*zip*") -or ($l -like "*href*avvepo*zip*"))
        {
            $alllinks += $l
        }
            
    }
    $allurls = @()
    foreach ($url in $alllinks)
    {
        $allurls += (($url.split('=')[1]).split('>')[0]).replace('"','')
    
    }
    #$allurls
    $newxdaturl = (($allurls | Select-string "xdat.exe").tostring())
    $newxdatepourl = (($allurls | Select-string "avvepo").tostring())
    $newmeddaturl = (($allurls | Select-string "mediumepo").tostring())
    $newintengurl = (($allurls | Select-string "engine/intel").tostring())
    $newv3daturl = (($allurls | Select-string "V3DAT/epoV3").tostring())
    
    $newxdat = ($newxdaturl.split('/')[-1])
    $newxdatepo = ($newxdatepourl.split('/')[-1])
    $newmeddat = ($newmeddaturl.split('/')[-1])
    $newinteng = ($newintengurl.split('/')[-1])
    $newv3dat = ($newv3daturl.split('/')[-1])
    
    if ($newxdat -ne $currentxdat)
    {
        write-host "New xdat available $($newxdat) " -ForegroundColor Green
        #write-host "     $($newxdaturl)" -ForegroundColor Gray
        Push-Location $fileoutput
        gci "*xdat.exe" -ErrorAction SilentlyContinue | Remove-Item
        Invoke-WebRequest -Uri $newxdaturl -OutFile $newxdat
        Pop-Location
        $currentxdat = $newxdat
        $change = $true
    }
    
    if ($newxdatepo -ne $currentxdatepo)
    {
        write-host "New xdat-epo available $($newxdatepo)" -ForegroundColor Green
        #write-host "     $($newxdatepourl)" -ForegroundColor Gray
        Push-Location $fileoutput
        gci "avvepo*.zip" -ErrorAction SilentlyContinue | Remove-Item
        Invoke-WebRequest -Uri $newxdatepourl -OutFile $newxdatepo
        Pop-Location
        $currentxdatepo = $newxdatepo
        $change = $true
    }
    
    if ($newmeddat -ne $currentmeddat)
    {
        write-host "New meddat available $($newmeddat)" -ForegroundColor Green
        #write-host "     $($newmeddaturl)" -ForegroundColor Gray
        Push-Location $fileoutput
        gci "mediumepo*.zip" -ErrorAction SilentlyContinue | Remove-Item
        Invoke-WebRequest -Uri $newmeddaturl -OutFile $newmeddat
        Pop-Location
        $currentmeddat = $newmeddat
        $change = $true
    }
    
    if ($newinteng -ne $currentinteng)
    {
        write-host "New scanning eng available $($newinteng)" -ForegroundColor Green
        #write-host "     $($newintengurl)" -ForegroundColor Gray
        Push-Location $fileoutput
        gci "epo*eng.zip" -ErrorAction SilentlyContinue | Remove-Item
        Invoke-WebRequest -Uri $newintengurl -OutFile $newinteng
        Pop-Location
        $currentinteng = $newinteng
        $change = $true
    }
    
    if ($newv3dat -ne $currentv3dat)
    {
        write-host "New v3dat available $($newv3dat)" -ForegroundColor Green
        #write-host "     $($newv3daturl)" -ForegroundColor Gray
        Push-Location $fileoutput
        gci "epoV3*.zip" -ErrorAction SilentlyContinue | Remove-Item
        Invoke-WebRequest -Uri $newv3daturl -OutFile $newv3dat
        Pop-Location
        $currentv3dat = $newv3dat
        $change = $true
    }

    if ($change)
    {
        Write-host "Changes were detected at $(get-date -Format "yyyy-MM-dd HH:mm:ss" )" -ForegroundColor Gray
        Write-host "   New files were automatically downloaded to $($fileoutput)`n`n" -ForegroundColor Gray
        Push-Location $fileoutput
        gci *.* | Where LastWriteTime -lt ((Get-Date).AddDays(-2)) | Remove-Item
        Pop-Location
    }
    
    Start-Sleep -Seconds 360

}