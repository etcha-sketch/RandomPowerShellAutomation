# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# Gets McAfee VSE Patch, DAT, and Managed information.

function Get-McAfeeInfo
{

$agentmode = (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\McAfee\Agent -Name AgentMode -ErrorAction SilentlyContinue).AgentMode
if ($agentmode -eq 1)
{
    $agentmode = 'Managed by ePO'
}
else
{
    $agentmode = 'Unmanaged'
}		

         $mcafeeinfo = New-Object -TypeName PSobject
         $mcafeeinfo | add-member NoteProperty "Managed State" -value $agentmode
         $mcafeeinfo | add-member NoteProperty "DAT Version" -value $((Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\McAfee\AVEngine -Name AVDatVersion -ErrorAction SilentlyContinue).AVDatVersion)
         $mcafeeinfo | Add-Member NoteProperty "DAT Date" -Value $((Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\McAfee\AVEngine -Name AVDatDate -ErrorAction SilentlyContinue).AVDatDate)
         $mcafeeinfo | Add-Member NoteProperty "Patch Level" -Value $(((Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\McAfee\DesktopProtection -Name CoreRef -ErrorAction SilentlyContinue).CoreRef.ToString().Split('P'))[1])



return $mcafeeinfo
}
