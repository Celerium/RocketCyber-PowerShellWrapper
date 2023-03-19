function Get-RocketCyberFirewalls {
<#
    .SYNOPSIS
        Gets RocketCyber firewalls from an account.

    .DESCRIPTION
        The Get-RocketCyberFirewalls cmdlet gets firewalls from
        an account.

    .PARAMETER accountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

        Multiple comma separated values can be inputted

    .PARAMETER deviceId
        The device ID tied to the device.

    .PARAMETER ipAddress
        The IP address tied to the device.

        As of 2023-03 this endpoint does not return
        IP address information

        Example:
            172.25.5.254

    .PARAMETER macAddress
        The MAC address tied to the device.

        Example:
            ae:b1:69:29:55:24

        Multiple comma separated values can be inputted

    .PARAMETER type
        The type of device.

        Example:
            SonicWall,Fortinet

        Multiple comma separated values can be inputted

    .PARAMETER page
        The target page of data.

        This is used with pageSize parameter to determine how many
        and which items to return.

        [Default] 1

    .PARAMETER pageSize
        The number of items to return from the data set.

        [Default] 1000
        [Maximum] 1000

    .PARAMETER sort
        The sort order for the items queried.

        Not all values can be sorted

        Example:
            accountId:asc
            accountId:desc

    .PARAMETER allPages
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberFirewalls

        Gets the first 1000 agents from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberFirewalls -accountId 12345

        The first 1000 firewalls are pulled from accountId 12345

    .EXAMPLE
        Get-RocketCyberFirewalls -macAddress '11:22:33:aa:bb:cc'

        Get the firewall with the defined macAddress

    .EXAMPLE
        Get-RocketCyberFirewalls -type SonicWall,Fortinet

        Get firewalls with the defined type

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Firewalls/Get-RocketCyberFirewalls.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByCreatedTime')]
    Param (
            [Parameter(Mandatory = $false)]
            [ValidateRange(1, [int64]::MaxValue)]
            [Int64[]]$accountId,

            [Parameter(Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String]$deviceId,

            [Parameter(Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String]$ipAddress,

            [Parameter(Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String[]]$macAddress,

            [Parameter(Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String[]]$type,

            [Parameter( Mandatory = $false )]
            [ValidateRange(1, [int]::MaxValue)]
            [Int]$page = 1,

            [Parameter( Mandatory = $false )]
            [ValidateRange(1, 1000)]
            [Int]$pageSize = 1000,

            [Parameter( Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String]$sort,

            [Parameter( Mandatory = $false)]
            [Switch]$allPages
    )

    begin{ $resource_Uri = '/firewalls' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 1000 }

        Set-Variable -Name 'RocketCyber_firewallParameters' -Value $PSBoundParameters -Scope Global -Force

        if ($allPages){
            Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages
        }
        else{
            Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters
        }

    }

    end{}

}
