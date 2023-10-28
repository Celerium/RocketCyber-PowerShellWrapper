function ConvertTo-RocketCyberQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-RocketCyberRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-RocketCyberRequest & any public functions that define parameters

    .PARAMETER uri_Filter
        Hashtable of values to combine a functions parameters with
        the resource_Uri parameter.

        This allows for the full uri query to occur

    .PARAMETER resource_Uri
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-RocketCyberQueryString -uri_Filter $uri_Filter -resource_Uri '/account'

        Example: (From public function)
            $uri_Filter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ){
                if( $excludedParameters -contains $Key.Key ){$null}
                else{ $uri_Filter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://api-us.rocketcyber.com/v3/account?accountId=12345
            2x key = https://api-us.rocketcyber.com/v3/account?accountId=12345&details=True

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/ConvertTo-RocketCyberQueryString.html

#>

    [CmdletBinding()]
    [alias("ConvertTo-RCQueryString")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [hashtable]$uri_Filter,

        [Parameter(Mandatory = $true)]
        [String]$resource_Uri
    )

    begin {}

    process {

        if (-not $uri_Filter) {
            return ""
        }

        $excludedParameters =   'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
                                'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable',
                                'allPages','startDate','endDate', 'eventSummary'

        $query_Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

        ForEach ( $Key in $uri_Filter.GetEnumerator() ){

            if( $excludedParameters -contains $Key.Key ){$null}
            elseif ( $Key.Value.GetType().IsArray ){
                Write-Verbose "[ $($Key.Key) ] is an array parameter"
                foreach ($Value in $Key.Value) {
                    #$ParameterName = $Key.Key
                    $query_Parameters.Add($Key.Key, $Value)
                }
            }
            else{
                $query_Parameters.Add($Key.Key, $Key.Value)
            }

        }

        # Build the request and load it with the query string.
        $uri_Request        = [System.UriBuilder]($RocketCyber_Base_URI + $resource_Uri)
        $uri_Request.Query  = $query_Parameters.ToString()

        return $uri_Request

    }

    end {}

}