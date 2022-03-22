function Get-RocketCyberIncidents {
<#
    .SYNOPSIS
        Gets an accounts incidents from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberIncidents cmdlet gets an accounts incidents from the RocketCyber API.

    .PARAMETER id
        Data will be retrieved from this account id.

    .PARAMETER status
        Data will be retrieved by these types of incidents.

        Acceptable values are:
            'all', 'open', 'closed'

        The default value is 'all'

    .PARAMETER startDate
        The starting date to search for incidents.

        This needs to be formatted like yyyy-MM-ddTHH:mm:ss.fffZ
        The inputted Date\Time is later converted to UTC time.

        Example:
        2022-03-17 13:00 = 2022-03-17T19:00:00.000Z

    .PARAMETER endDate
        The ending date to stop searching for incidents.

        This needs to be formatted like yyyy-MM-ddTHH:mm:ss.fffZ
        The inputted Date\Time is later converted to UTC time.

        Example:
        2022-03-17 13:00 = 2022-03-17T19:00:00.000Z

    .PARAMETER sortBy
        Data will be sorted by this property.

        Acceptable values are:
            'created', 'closed', 'updated'

        The default value is 'created'

    .PARAMETER orderBy
        Data will be returned in this order

        sortBy is required if orderBy is defined.

        Acceptable values are:
            'asc', 'desc'

        The default value is 'desc'

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
            "totalCount": 1,
            "currentPage": 1,
            "totalPages": 1,
            "dataCount": 1,
            "data": [
                {
                "id": "12345",
                "title": "Webroot Detection - ",
                "description": "Webroot detected and remediated the following file:\r\n",
                "remediation": "Review the detection.\r\nRun a full AV scan of the system.\r\nWhitelist if appropriate.",
                "resolvedAt": "2001-03-10T21:02:18.112Z",
                "publishedAt": "2001-03-06T03:07:06.389Z",
                "createdAt": "2001-03-06T03:07:06.371Z",
                "updatedAt": "2001-07-29T21:50:13.848Z",
                "status": "closed"
                }
            ]
        }

    .EXAMPLE
        Get-RocketCyberIncidents -id 12345

        Gets the first 1000 incidents for account id 12345. Data is sorted by created and returned in descending order.

    .EXAMPLE
        Get-RocketCyberIncidents -id 12345 -sortBy open -orderBy asc

        Gets the first 1000 incidents for account id 12345. Data is sorted by open and returned in ascending order.

    .EXAMPLE
        Get-RocketCyberIncidents -id 12345 -startDate '2022-03-17 13:00' -endDate '2022-03-18 13:00'

        Gets the first 1000 incidents for account id 12345 between 2022-03-17 13:00 & 2022-03-18 13:00.
        Data is sorted by created and returned in descending order.

        The inputted Date\Time is converted to UTC time.
            2022-03-17 13:00 = 2022-03-17T19:00:00.000Z
            2022-03-18 13:00 = 2022-03-18T19:00:00.000Z

    .EXAMPLE
        Get-RocketCyberIncidents -id 12345 -startDate '2022-03-17 13:00'

        Gets the first 1000 incidents for account id 12345 between 2022-03-17 13:00 & the present date.
        Data is sorted by created and returned in descending order.

        The inputted Date\Time is converted to UTC time.
            2022-03-17 13:00 = 2022-03-17T19:00:00.000Z
            2022-03-18 13:00 = 2022-03-18T19:00:00.000Z

    .EXAMPLE
        Get-RocketCyberIncidents -id 12345 -pageNumber 2 -pageSize 100

        Gets the first 100 incidents for account id 12345. Data is returned 100 at a time and shown starting on page 2.
        Data is sorted by created and returned in descending order.

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
        [ValidateSet( 'all', 'open', 'closed' )]
        [string]$status = 'all',

        [Parameter(ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [dateTime]$startDate,

        [Parameter(ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [dateTime]$endDate,

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet( 'created', 'closed', 'updated' )]
        [string]$sortBy = 'created',

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet( 'asc', 'desc' )]
        [string]$orderBy = 'desc',

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int64]$pageNumber = '1',

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1,1000)]
        [int]$pageSize = '1000'
    )

    $resource_uri = "/$id/incidents"

    $body = @{}

    if ($PSCmdlet.ParameterSetName -eq 'index') {

        if ($status){
            $body += @{'status' = $status}
        }

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
