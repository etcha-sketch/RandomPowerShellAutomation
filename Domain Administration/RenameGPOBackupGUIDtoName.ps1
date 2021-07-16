# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function GetStringBetweenTwoStrings($firstString, $secondString, $data){

    #Regex pattern to compare two strings
    $pattern = "$firstString(.*?)$secondString"

    #Perform the operation
    $result = [regex]::Match($data,$pattern).Groups[1].Value

    #Return result
    return $result

}

$location = "C:\GPOBackups\"
Push-Location $location

foreach ($guid in ((Get-ChildItem).Name))
{
Push-Location $guid
$cdata = Get-Content bkupInfo.xml


$first = "<GPODisplayName>"
$last = "</GPODisplayName>"

$name = getstringbetweentwostrings -firstString $first -secondString $last -data $cdata
$name = $name.Replace("<![CDATA[", "")
$name = $name.Replace("]]>", "")

write-host $name
Pop-Location
New-Item -ItemType directory -Name "$($name)"
Move-Item $guid "$($name)"



Clear-Variable name
Clear-Variable cdata

}
Pop-Location
