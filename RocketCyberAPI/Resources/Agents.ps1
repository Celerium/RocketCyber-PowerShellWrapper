function Get-RocketCyberAgents {
<#
    .SYNOPSIS
        Gets an accounts agents from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberAgents cmdlet gets an accounts agents from the RocketCyber API.

    .PARAMETER id
        Data will be retrieved from this account id.

    .PARAMETER filterBy
        Data will be filtered by this property

        filterValue is required if filterBy is defined.

        Acceptable values are:
            'connectivity'

    .PARAMETER filterValue
        Data will be filtered by this property value

        filterBy is required if filterValue is defined.

        Acceptable values are:
            'online', 'offline', 'isolated'

    .PARAMETER sortBy
        Data will be sorted by this property.

        Acceptable values are:
            'id', 'hostname', 'agentVersion', 'lastConnected'

        The default value is 'id'

    .PARAMETER orderBy
        Data will be returned in this order

        sortBy is required if orderBy is defined.

        Acceptable values are:
            'asc', 'desc'

        The default value is 'desc'

    .EXAMPLE
        Example Response Body:

            {
                "totalCount": 2,
                "currentPage": 1,
                "totalPages": 1,
                "dataCount": 2,
                "data": [
                    {
                    "id": "asgybc73jbcuds",
                    "customer_id": 1,
                    "hostname": "WS-JSDHGFKSD",
                    "ipv4_address": "11.12.73.211",
                    "mac_address": "E9:61:82:BL:33:67",
                    "created_at": "2021-12-15T01:22:08.627Z",
                    "platform": "MacOS",
                    "family": "Apple",
                    "version": "10",
                    "edition": "Pro",
                    "architecture": "64-bit",
                    "build": "12345",
                    "release": "2003",
                    "account_path": "2.1",
                    "agent_version": "v0.4 \"beta\" Build (12345)",
                    "connectivity": "offline",
                    "lastConnected": "2021-12-07T17:51:34.218Z"
                    }
                ]
            }

    .EXAMPLE
        Get-RocketCyberAgents -id 12345

        Gets the first 1000 agents from account 12345.

        Data is sorted by id and returned in descending order.

    .EXAMPLE
        Get-RocketCyberAgents -id 12345 -sortBy hostname -orderBy asc

        Gets the first 1000 agents from account 12345.

        Data is sorted by hostname and returned in ascending order.

    .EXAMPLE
        Get-RocketCyberAgents -id 12345 -filterBy connectivity -filterValue offline

        Gets the first 1000 offline agents from account 12345.

        Data is sorted by id and returned in descending order.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/RocketCyber-PowerShellWrapper
        https://api-doc.rocketcyber.com/
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
            [Parameter(Mandatory = $true , ParameterSetName = 'index')]
            [ValidateRange(1, [int]::MaxValue)]
            [Int64]$id,

            [Parameter(ParameterSetName = 'index')]
            [ValidateSet( 'connectivity' )]
            [string]$filterBy,

            [Parameter(ParameterSetName = 'index')]
            [ValidateSet( 'online', 'offline', 'isolated' )]
            [string]$filterValue,

            [Parameter(ParameterSetName = 'index')]
            [ValidateSet( 'id', 'hostname', 'agentVersion', 'lastConnected' )]
            [string]$sortBy = 'id',

            [Parameter(ParameterSetName = 'index')]
            [ValidateSet( 'asc', 'desc' )]
            [string]$orderBy = 'desc'
    )

    $resource_uri = "/$id/agents"

    $body = @{}

    if ($PSCmdlet.ParameterSetName -eq 'index') {

        if ($filterBy){
            $body += @{'filterBy' = $filterBy}
        }

        if ($filterValue){
            $body += @{'filterValue' = $filterValue}
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
