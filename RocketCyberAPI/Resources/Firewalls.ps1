function Get-RocketCyberFirewalls {
<#
    .SYNOPSIS
        Gets an accounts firewalls from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberFirewalls cmdlet gets an accounts firewalls from the RocketCyber API.

    .PARAMETER id
        Data will be retrieved from this account id.

    .PARAMETER startDate
        The starting date to search for firewalls.

        This needs to be formatted like yyyy-MM-ddTHH:mm:ss.fffZ
        The inputted Date\Time is later converted to UTC time.

        Example:
        2022-03-17 13:00 = 2022-03-17T19:00:00.000Z

    .PARAMETER endDate
        The ending date to stop searching for firewalls.

        This needs to be formatted like yyyy-MM-ddTHH:mm:ss.fffZ
        The inputted Date\Time is later converted to UTC time.

        Example:
        2022-03-17 13:00 = 2022-03-17T19:00:00.000Z

    .PARAMETER sortBy
        Data will be sorted by this property.

        Acceptable values are:
            'id', 'createdAt'

        The default value is 'id'

    .PARAMETER orderBy
        Data will be returned in this order

        sortBy is required if orderBy is defined.

        Acceptable values are:
            'asc', 'desc'

        The default value is 'asc'

    .PARAMETER pageNumber
        Defines the page number to return.

        The default value is 1

    .PARAMETER pageSize
        Defines the amount of items to return with each page.

        The maximum page size allowed is 1000

        The default value is 1000

    .EXAMPLE
        Example Response Body:

        {
            "totalCount": 3,
            "currentPage": 1,
            "totalPages": 1,
            "dataCount": 3,
            "counters": {
                "received": 4595611,
                "parsed": 4595669,
                "filtered": 4530438,
                "reported": 65854
            },
            "data": [
                {
                "id": "149329",
                "accountPath": "51.3.135",
                "details": {
                    "type": "fortinet",
                    "device_id": "123456789"
                },
                "createdAt": "2021-04-19T00:14:32.146Z",
                "instanceType": "firewall"
                },
                {
                "id": "149328",
                "accountPath": "51.3.135",
                "details": {
                    "type": "fortinet",
                    "device_id": "123456789"
                },
                "createdAt": "2021-04-18T23:50:08.196Z",
                "instanceType": "firewall"
                },
                {
                "id": "149327",
                "accountPath": "51.3.135",
                "details": {
                    "type": "fortinet",
                    "device_id": "123456789"
                },
                "createdAt": "2021-04-18T23:50:04.161Z",
                "instanceType": "firewall"
                }
            ]
        }

    .EXAMPLE
        Get-RocketCyberFirewalls -id 12345

        Gets the first 1000 firewalls for account id 12345. Data is sorted by id and returned in ascending order.

    .EXAMPLE
        Get-RocketCyberFirewalls -id 12345 -sortBy id -orderBy desc

        Gets the first 1000 firewalls for account id 12345. Data is sorted by id and returned in descending order.

    .EXAMPLE
        Get-RocketCyberFirewalls -id 12345 -startDate '2022-03-17 13:00' -endDate '2022-03-18 13:00'

        Gets the first 1000 firewalls for account id 12345 that were created between 2022-03-17 13:00 & 2022-03-18 13:00.
        Data is sorted by id and returned in ascending order.

        The inputted Date\Time is converted to UTC time.
            2022-03-17 13:00 = 2022-03-17T19:00:00.000Z
            2022-03-18 13:00 = 2022-03-18T19:00:00.000Z

    .EXAMPLE
        Get-RocketCyberFirewalls -id 12345 -startDate '2022-03-17 13:00'

        Gets the first 1000 firewalls for account id 12345 that were created between 2022-03-17 13:00 & the present date.
        Data is sorted by id and returned in ascending order.

        The inputted Date\Time is converted to UTC time.
            2022-03-17 13:00 = 2022-03-17T19:00:00.000Z
            2022-03-18 13:00 = 2022-03-18T19:00:00.000Z

    .EXAMPLE
        Get-RocketCyberFirewalls -id 12345 -pageNumber 2 -pageSize 100

        Gets the first 100 firewalls for account id 12345. Data is returned 100 at a time and shown starting on page 2.
        Data is sorted by id and returned in ascending order.

    .NOTES
        Look into a better startDate & endDate handling method

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
        [ValidateNotNullOrEmpty()]
        [dateTime]$startDate,

        [Parameter(ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [dateTime]$endDate,

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet( 'id', 'createdAt' )]
        [string]$sortBy = 'id',

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet( 'asc', 'desc' )]
        [string]$orderBy = 'asc',

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int64]$pageNumber = '1',

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1,1000)]
        [int]$pageSize = '1000'
    )

    $resource_uri = "/$id/firewalls"

    $body = @{}

    if ($PSCmdlet.ParameterSetName -eq 'index') {

        if ($startDate){
            $body += @{'startDate' = ($startDate).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")}
        }

        if ($endDate){
            $body += @{'endDate' = ($endDate).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")}
        }

        if ($sortBy){
            $body += @{'sortBy' = $sortBy}
        }

        if ($orderBy){
            $body += @{'orderBy' = $orderBy}
        }

        if ($pageNumber){
            $body += @{'page' = $pageNumber}
        }

        if ($pageSize){
            $body += @{'pageSize' = $pageSize}
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
