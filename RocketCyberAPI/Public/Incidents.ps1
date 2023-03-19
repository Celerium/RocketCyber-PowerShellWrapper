function Get-RocketCyberIncidents {
<#
    .SYNOPSIS
        Gets incident information from the RocketCyber API

    .DESCRIPTION
        The Get-RocketCyberIncidents cmdlet gets incident information
        associated to all or a defined account ID.

    .PARAMETER id
        The RocketCyber incident ID.

        Multiple comma separated values can be inputted

    .PARAMETER title
        The title of the incident.

        Example:
            Office*

        Multiple comma separated values can be inputted

    .PARAMETER accountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

        Multiple comma separated values can be inputted

    .PARAMETER description
        The description of the incident.

        NOTE: Wildcards are required to search for specific text.

        Example:
            administrative

    .PARAMETER remediation
        The remediation for the incident.

        NOTE: Wildcards are required to search for specific text.

        Example:
            permission*

        As of 2023-03 this parameters does not appear to work

    .PARAMETER resolvedAt
        This returns incidents resolved between the start and end date.

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Start Time  |  End Time

        Example:
            2022-05-09  |2022-05-10
            2022-05-09  |
                        |2022-05-10

    .PARAMETER createdAt
        This returns incidents created between the start and end date.

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Start Time  |  End Time

        Example:
            2022-05-09  |2022-05-10
            2022-05-09  |
                        |2022-05-10

    .PARAMETER status
        The type of incidents to request.

        Allowed Values:
            'open', 'resolved'

        As of 2023-03 the documentation defines the
        allowed values listed below but not all work

        'all', 'open', 'closed'

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
            title:desc

    .PARAMETER allPages
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberIncidents

        Gets the first 1000 incidents from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberIncidents -accountId 12345 -Id 9876

        Gets the defined incident Id from the defined accountId

    .EXAMPLE
        Get-RocketCyberIncidents -title nmap -resolvedAt '2023-01-01|'

        Gets the first 1000 incidents from all accounts accessible
        by the bearer token that were resolved after the defined
        startDate with the defined word in the title.

    .EXAMPLE
        Get-RocketCyberIncidents -description audit -createdAt '|2023-03-01'

        Gets the first 1000 incidents from all accounts accessible
        by the bearer token that were created before the defined
        endDate with the defined word in the description.

    .EXAMPLE
        Get-RocketCyberIncidents -status resolved -sort title:asc

        Gets the first 1000 resolved incidents from all accounts accessible
        by the bearer token and the data is return by title in
        ascending order.

    .NOTES
        As of 2023-03:
            Any parameters that say wildcards are required is not valid

            Using wildcards in the query string do not work as the endpoint
            already search's via wildcard. If you use a wildcard '*' it
            will not return any results.

        The remediation parameter does not appear to work

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Incidents/Get-RocketCyberIncidents.html

#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
            [Parameter(Mandatory = $false)]
            [ValidateRange(1, [int]::MaxValue)]
            [Int[]]$id,

            [Parameter(Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String[]]$title,

            [Parameter(Mandatory = $false)]
            [ValidateRange(1, [int64]::MaxValue)]
            [Int64[]]$accountId,

            [Parameter(Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String[]]$description,

            [Parameter(Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String]$remediation,

            [Parameter( Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String]$resolvedAt,

            [Parameter( Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [String]$createdAt,

            [Parameter(Mandatory = $false)]
            [ValidateSet( 'open', 'resolved' )]
            [String[]]$status,

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

    begin{ $resource_Uri = '/incidents' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 1000 }

        Set-Variable -Name 'RocketCyber_incidentParameters' -Value $PSBoundParameters -Scope Global -Force

        if ($allPages){
            Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages
        }
        else{
            Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters
        }

    }

    end{}

}
