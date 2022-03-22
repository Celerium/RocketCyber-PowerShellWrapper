function Get-RocketCyberApps {
<#
    .SYNOPSIS
        Gets an accounts apps from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberApps cmdlet gets an accounts apps from the RocketCyber API.

    .PARAMETER id
        Data will be retrieved from this account id.

    .PARAMETER status
        Data will be retrieved by these status types.

        Acceptable values are:
            'active', 'inactive'

        The default value is 'active'

    .PARAMETER sortBy
        Data will be sorted by this property.

        Acceptable values are:
            'id', 'name'

        The default value is 'id'

    .PARAMETER orderBy
        Data will be returned in this order

        sortBy is required if orderBy is defined.

        Acceptable values are:
            'asc', 'desc'

        The default value is 'asc'

    .EXAMPLE
        Example Response Body:

        {
            "totalCount": 36,
            "currentPage": 1,
            "totalPages": 1,
            "dataCount": 36,
            "data": [
                {
                    "id": 23,
                    "name": "Webroot Monitor",
                    "description": "This app reports on detections from Webroot"
                },
                {
                    "id": 75,
                    "name": "VSA Threat Hunt",
                    "description": "This app monitors the Kaseya VSA Kworking folder looking for known malware attack files."
                }
            ]
        }

    .EXAMPLE
        Get-RocketCyberApps -id 12345

        Gets active apps from account 12345.

        Data is sorted by id and returned in ascending order.

    .EXAMPLE
        Get-RocketCyberApps -id 12345 -sortBy name -orderBy desc

        Gets active apps from account 12345.

        Data is sorted by name and returned in descending order.

    .EXAMPLE
        Get-RocketCyberApps -id 12345 -status inactive

        Gets inactive apps from account 12345.

        Data is sorted by id and returned in ascending order.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/RocketCyber-PowerShellWrapper
        https://api-doc.rocketcyber.com/
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true , ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int64]$id,

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet( 'active', 'inactive' )]
        [string]$status = 'active',

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet( 'id', 'name' )]
        [string]$sortBy = 'id',

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet( 'asc', 'desc' )]
        [string]$orderBy = 'asc'
    )

    $resource_uri = "/$id/apps"

    $body = @{}

    if ($PSCmdlet.ParameterSetName -eq 'index') {

        if ($status){
            $body += @{'status' = $status}
        }

        if ($sortBy){
            $body += @{'sortBy' = $sortBy}
        }

        if ($orderBy){
            $body += @{'orderBy' = $orderBy}
        }

    }

    try {
        if ($null -eq $RocketCyber_API_Key) {
            throw "The RocketCyber API access token is not set. Run Add-RocketCyberAPIKey to set the API access token."
        }

        $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($RocketCyber_API_Key)
        $Bearer_Token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key)
        $RocketCyber_Headers.Add('Authorization', "Bearer $Bearer_Token")

        $rest_output = Invoke-RestMethod -method 'GET' -uri ( $RocketCyber_Base_URI + $resource_uri ) -headers $RocketCyber_Headers `
            -body $body -ErrorAction Stop -ErrorVariable web_error
    } catch {
        Write-Error $_
    } finally {
        [void] ($RocketCyber_Headers.Remove('Authorization'))
        if ($Api_Key) {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
        }
    }

    $data = @{}
    $data = $rest_output
    return $data

}
