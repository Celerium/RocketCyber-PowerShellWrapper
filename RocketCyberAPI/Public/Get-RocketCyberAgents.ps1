function Get-RocketCyberAgents {
<#
    .SYNOPSIS
        Gets RocketCyber agents from an account.

    .DESCRIPTION
        The Get-RocketCyberAgents cmdlet gets agent information
        for all accounts or for agents associated to an account ID.

    .PARAMETER accountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

        Multiple comma separated values can be inputted

    .PARAMETER id
        The agent id

        Multiple comma separated values can be inputted

    .PARAMETER hostname
        The device hostname

        Multiple comma separated values can be inputted

    .PARAMETER ip
        The IP address tied to the device

        Multiple comma separated values can be inputted

    .PARAMETER created
        The date range for when agents were created

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Cannot be used with the startDate & endDate parameters

        Start UTC Time | End UTC Time

        Example:
            2022-05-09T00:33:38.245Z|2022-05-10T23:59:38.245Z
            2022-05-09T00:33:38.245Z|
                                    |2022-05-10T23:59:38.245Z

    .PARAMETER startDate
        The friendly start date for when agents were created

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Cannot be used with the created parameter

        Date needs to be inputted as yyyy-mm-dd hh:mm:ss

        Example:
            2022-05-09 12:30:10

    .PARAMETER endDate
        The friendly end date for when agents were created

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Cannot be used with the created parameter

        Date needs to be inputted as yyyy-mm-dd hh:mm:ss

        Example:
            2022-05-09 12:30:10

    .PARAMETER os
        The OS used by the device

        As of 2023-03 using * do not appear to work correctly

        Example:
            Windows*
            Windows

    .PARAMETER version
        The agent version.

        As of 2023-03 this filter appears not to work correctly

        Example:
            Server 2019

    .PARAMETER connectivity
        The connectivity status of the agent

        Multiple comma separated values can be inputted

        Allowed values:
            'online', 'offline', 'isolated'

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
            hostname:asc
            accountId:desc

    .PARAMETER allPages
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberAgents

        Gets the first 1000 agents from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberAgents -id 12345

        Gets the first 1000 agents from account 12345.

    .EXAMPLE
        Get-RocketCyberAgents -id 12345 -sort hostname:asc

        Gets the first 1000 agents from account 12345.

        Data is sorted by hostname and returned in ascending order.

    .EXAMPLE
        Get-RocketCyberAgents -id 12345 -connectivity offline,isolated

        Gets the first 1000 offline agents from account 12345 that are
        either offline or isolated.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Agents/Get-RocketCyberAgents.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Get-RCAgents")]
    Param (
        [Parameter( Mandatory = $false) ]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$accountId,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$id,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$hostname,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$ip,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [String]$created,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByCustomTime')]
        [ValidateNotNullOrEmpty()]
        [DateTime]$startDate,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByCustomTime')]
        [ValidateNotNullOrEmpty()]
        [DateTime]$endDate,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$os,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$version,

        [Parameter( Mandatory = $false) ]
        [ValidateSet( 'online', 'offline', 'isolated' )]
        [String[]]$connectivity,

        [Parameter( Mandatory = $false ) ]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$page,

        [Parameter( Mandatory = $false ) ]
        [ValidateRange(1, 1000)]
        [Int]$pageSize,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$sort,

        [Parameter( Mandatory = $false) ]
        [Switch]$allPages
    )

    begin{ $resource_Uri = '/agents' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 1000 }

        if ($PSCmdlet.ParameterSetName -eq 'indexByCustomTime') {

            if ($startDate) {
                $startTime    = $startDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                Write-Verbose "Converting [ $startDate ] to [ $startTime ]"
            }
            if ($endDate)   {
                $endTime      = $endDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                Write-Verbose "Converting [ $endDate ] to [ $endTime ]"
            }

                if ([bool]$startDate -eq $true -and [bool]$endDate -eq $true) {
                    $created_query = $startTime + '|' + $endTime
                }
                elseif ([bool]$startDate -eq $true -and [bool]$endDate -eq $false) {
                    $created_query = $startTime + '|'
                }
                else{
                    $created_query = '|' + $endTime
                }

            $PSBoundParameters += @{ 'created' = $created_query }

        }

        Set-Variable -Name 'RocketCyber_agentParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end{}

}
