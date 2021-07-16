# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function Get-AvailableDriveLetter
{
    param([Parameter(Mandatory=$true)]
    [string]$DesiredDriveLetter)
    $lettertable =@{"a"=1;"b"=2;"c"=3;"d"=4;"e"=5;"f"=6;"g"=7;"h"=8;"i"=9;"j"=10;"k"=11;"l"=12;"m"=13;"n"=14;"o"=15;"p"=16;"q"=17;"r"=18;"s"=19;"t"=20;"u"=21;"v"=22;"w"=23;"x"=24;"y"=25;"z"=26}

    $numbertable =@{2="b";13="m";17="q";26="z";19="s";22="v";24="x";25="y";18="r";21="u";16="p";7="g";5="e";11="k";20="t";12="l";14="n";15="o";8="h";6="f";10="j";9="i";23="w";4="d";1="a";3="c"}

    $allinuse = get-psdrive
    $allinuseletters = $allinuse.Name

    

    $loop = 0

    while ($loop -ne 1)
    {
        if ($allinuseletters -contains $DesiredDriveLetter)
        {
           write-verbose "$($DesiredDriveLetter) is already in use, incrementing letter now."
           $tonum = $lettertable.$($DesiredDriveLetter) + 1
           if ($tonum -eq 27) {$tonum = 1}
           $DesiredDriveLetter = $numbertable.$($tonum)
           Clear-Variable tonum
        }
        else
        {
            write-verbose "$($DesiredDriveLetter) not in use, setting return variable."
            $newletter = $DesiredDriveLetter
            $loop = 1
        }


    }

    Write-verbose "Next available drive letter is $($newletter)"
    Return $newletter
}
