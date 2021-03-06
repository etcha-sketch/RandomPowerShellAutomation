# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function Show-Menu 
{ 
     param ( 
           [string]$Title = 'My Menu' 
     ) 
     Clear-Host
     Write-Host "================ $Title ================" 
     
     Write-Host "1: Press '1' for this option." 
     Write-Host "2: Press '2' for this option." 
     Write-Host "3: Press '3' for this option." 
     Write-Host "Q: Press 'Q' to quit." 
} 




do 
{ 
     Show-Menu 
     $input = Read-Host "Please make a selection" 
     switch ($input) 
     { 
           '1' { 
                Clear-Host
                'You chose option #1' 
           } '2' { 
                Clear-Host
                'You chose option #2' 
           } '3' { 
                Clear-Host
                'You chose option #3' 
           } 'q' { 
                return 
           } 
     } 
     pause 
} 
until ($input -eq 'q') 
