# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

# Requires ActiveDirectory PS Module.
# Only goes into two nested groups. If you have more, add the logic to this script or get a different tool.
# This is designed for small AD deployments.
Import-Module ActiveDirectory
 
$Groups = Get-AdGroup -Properties * -Filter * -SearchBase "DC=domain,DC=com" | Where Name -ne "Domain Computers" | Where Name -ne "Domain Users"
 
$Table = @()
 
$Record = [ordered]@{
"Group Name" = ""
"Name" = ""
"Username" = ""
"Nested" = ""
}
 
Foreach ($Group in $Groups)
{
 
$Arrayofmembers = Get-ADGroupMember -identity $Group | select name,samaccountname,ObjectClass
 
foreach ($Member in $Arrayofmembers)
{

    if ($Member.ObjectClass -ne "group")
    {
    $Record."Group Name" = $Group.name
    $Record."Sec/Distro" = $Group.GroupCategory
    $Record."Name" = $Member.name
    $Record."UserName" = $Member.samaccountname
    $Record."Nested" = "False"
    $objRecord = New-Object PSObject -property $Record
    $Table += $objrecord
    }
    elseif ($Member.ObjectClass -eq "group")
    {
        $Record."Group Name" = $Group.name
        $Record."Sec/Distro" = $Group.GroupCategory
        $Record."Name" = "GROUP-$($Member.name)"
        $Record."UserName" = $Member.samaccountname
        $Record."Nested" = "[$($member.name)] Group Nested in [$($group.name)] Group"
        $objRecord = New-Object PSObject -property $Record
        $Table += $objrecord
        foreach ($nestedmember in (Get-ADGroupMember -identity $Member.name | select name,samaccountname,ObjectClass))
        {
			# Nested Group
			$Record."Group Name" = $Group.name
			$Record."Sec/Distro" = $Group.GroupCategory
			$Record."Name" = $nestedMember.name
			$Record."UserName" = $nestedMember.samaccountname
			$Record."Nested" = "Nested in [$($member.name)]"
			$objRecord = New-Object PSObject -property $Record
			$Table += $objrecord
			if ($nestedMember.ObjectClass -eq "group")
			{
				# Double nested group
				$Record."Group Name" = $Member.name
				$Record."Sec/Distro" = $Group.GroupCategory
				$Record."Name" = "2XGROUP-$($NestedMember.name)"
				$Record."UserName" = $NestedMember.samaccountname
				$Record."Nested" = "[$($member.name)] Group Double Nested in [$($group.name)] Group"
				$objRecord = New-Object PSObject -property $Record
				$Table += $objrecord
				foreach ($nestedmember2 in (Get-ADGroupMember -identity $nestedmember.name | select name,samaccountname,ObjectClass))
				{
					$Record."Group Name" = $nestedmember.name
					$Record."Sec/Distro" = $Group.GroupCategory
					$Record."Name" = $nestedMember2.name
					$Record."UserName" = $nestedMember2.samaccountname
					$Record."Nested" = " Double Nested in [$($nestedmember.name)]"
					$objRecord = New-Object PSObject -property $Record
					$Table += $objrecord
				}
			}
        }
    }
}
 
}
 
$Table | export-csv "C:\DomainGroupAudit-$(Get-Date -Format yyyy-MM-dd).csv" -NoTypeInformation
