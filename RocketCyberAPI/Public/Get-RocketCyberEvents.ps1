function Get-RocketCyberEvents {
<#
    .SYNOPSIS
        Gets app event information from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberEvents cmdlet gets app event information for
        events associated to all or a defined account ID.

        Use the Get-RockerCyberApp cmdlet to get app ids

    .PARAMETER appId
        The app ID.

    .PARAMETER verdict
        The verdict of the event.

        Multiple comma separated values can be inputted

        Allowed Values:
        'informational', 'suspicious', 'malicious'

    .PARAMETER accountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

        Multiple comma separated values can be inputted

    .PARAMETER eventSummary
        Shows summary of events for each app

    .PARAMETER details
        This parameter allows users to target specific attributes within the details object.

        This requires you to define the attribute path (period separated) and the expected value.

        The value can include wildcards (*)

        Example: (appId 7)
            attributes.direction:outbound

    .PARAMETER dates
        The date range for event detections.

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Cannot be used with the startDate & endDate parameters

        Start Time  |  End Time

        Example:
            2022-05-09  |2022-05-10
            2022-05-09  |
                        |2022-05-10

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
            verdict:asc
            dates:desc

    .PARAMETER allPages
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberEvents -appId 7

        Gets the first 1000 appId 7 events from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberEvents -accountId 12345 -appId 7

        Gets the first 1000 appId 7 events from account 12345

    .EXAMPLE
        Get-RocketCyberEvents -appId 7 -sort dates:desc

        Gets the first 1000 appId 7 events and the data set is sort
        by dates in descending order.

    .EXAMPLE
        Get-RocketCyberEvents -appId 7 -verdict suspicious

        Gets the first 1000 appId 7 events and the data set is sort
        by dates in descending order.

    .NOTES
        As of 2023-03
            Other than the parameters shown here, app specific parameters vary from app to app,
            however I have not found any documentation around this.

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Events/Get-RocketCyberEvents.html

#>

    [CmdletBinding(DefaultParameterSetName = 'indexByEvent')]
    [alias("Get-RCEvents")]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByEvent')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$appId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateSet( 'informational', 'suspicious', 'malicious' )]
        [String[]]$verdict,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEventSummary')]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$accountId,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByEventSummary')]
        [Switch]$eventSummary,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateNotNullOrEmpty()]
        [String]$details,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateNotNullOrEmpty()]
        [String]$dates,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$page,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateRange(1, 1000)]
        [Int]$pageSize,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateNotNullOrEmpty()]
        [String]$sort,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [Switch]$allPages
    )

    begin{

        switch ( [bool]$eventSummary ) {
            $true   { $resource_uri = "/events/summary" }
            $false  { $resource_uri = "/events" }
        }

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if ( $($PSCmdlet.ParameterSetName) -eq 'indexByEvent' ){

            if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
            if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 1000 }

        }

        Set-Variable -Name 'RocketCyber_eventParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end{}

}
