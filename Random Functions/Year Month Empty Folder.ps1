# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

Set-Location "$($env:userprofile)\Desktop\New Folder"
$years = "2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"
$months = "01 January","02 Feburary","03 March","04 April","05 May","06 June","07 July","08 August","09 September","10 October","11 November","12 December" 
$weeks = "Week 1","Week 2", "Week 3", "Week 4"

foreach ($year in $years)
{
    New-Item -ItemType directory $year | Out-Null
    foreach ($month in $months)
    {
        New-Item -ItemType directory $year\$year-$month | Out-Null
        # Uncomment the lines below if you want weekly folders as well.
		#foreach ($week in $weeks)
        #{
        #    New-Item -ItemType directory $year\$month\$week   
        #    
        #}
    }
}
