# github.com/etcha-sketch
# 07/16/2021
# This script is a part of the RandomPowerShellAutomation repository
# These scripts were/are not all polished, and may require some customization to work.

# Use at your own risk

function Enable-DHCP
{
    param([switch]$Verbose)
    #Setting an address with DHCP
    $IPType = "IPv4"
    $adapter = Get-NetAdapter -Name "Ethernet*" | ? {$_.Status -eq "up"}
    $interface = $adapter | Get-NetIPInterface -AddressFamily $IPType
    If ($interface.Dhcp -eq "Disabled")
    {
        # Remove existing gateway
        If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway)
        {
            if ($verbose) {Write-Output "Removing Default Gateway"}
            $interface | Remove-NetRoute -Confirm:$false
    
        }
         # Enable DHCP
            if ($verbose) {Write-Output "Enabling DHCP"}
            $interface | Set-NetIPInterface -DHCP Enabled
         # Configure the DNS Servers automatically
            if ($verbose) {Write-Output "Setting Auto DNS Server"}
            $interface | Set-DnsClientServerAddress -ResetServerAddresses
    }
}

function Set-StaticIP
{
    param([string]$IP = $null,
    [string]$SubnetMask = $null,
    [string]$Gateway = $null,
    [array]$DnsServer = @("10.10.10.10","10.10.10.11"),
    $MaskBits = $null
    )


    if (($SubnetMask -eq $null) -and ($MaskBits -eq $null))
    {
        Write-host "I'm confused, no maskbits or subnet mask provided"
    }
    elseif ($MaskBits -eq $null)
    {
        Switch ($SubnetMask)
        {
            "255.255.255.0" {$MaskBits = 24}
            "255.255.255.128" {$MaskBits = 25}
            "255.255.255.192" {$MaskBits = 26}
            "255.255.255.224" {$MaskBits = 27}
            "255.255.255.240" {$MaskBits = 28}
            "255.255.255.248" {$MaskBits = 29}

        }
    }

    #Write-host "Maskbits: $($MaskBits)"
    #Write-host "SubnetMask: $($SubnetMask)"

    $IPType = "IPv4"
    # Retrieve the network adapter that you want to configure
    $adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
    # Remove any existing IP, gateway from our ipv4 adapter
    If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
     $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
    }
    If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
     $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
    }
     # Configure the IP address and default gateway
    $adapter | New-NetIPAddress `
     -AddressFamily $IPType `
     -IPAddress $IP `
     -PrefixLength $MaskBits `
     -DefaultGateway $Gateway | Out-null
    # Configure the DNS client server IP addresses
    $adapter | Set-DnsClientServerAddress -ServerAddresses $DnsServer | Out-null
}
