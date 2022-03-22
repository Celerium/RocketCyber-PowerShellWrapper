function Get-RocketCyberEvents {
<#
    .SYNOPSIS
        Gets an accounts events from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberEvents cmdlet gets an accounts events from the RocketCyber API.

    .PARAMETER id
        Data will be retrieved from this account id.

    .PARAMETER startDate
        The starting date to search for events.

        This needs to be formatted like yyyy-MM-ddTHH:mm:ss.fffZ
        The inputted Date\Time is later converted to UTC time.

        Example:
        2022-03-17 13:00 = 2022-03-17T19:00:00.000Z

    .PARAMETER endDate
        The ending date to stop searching for events.

        This needs to be formatted like yyyy-MM-ddTHH:mm:ss.fffZ
        The inputted Date\Time is later converted to UTC time.

        Example:
        2022-03-17 13:00 = 2022-03-17T19:00:00.000Z

    .PARAMETER filterBy
        Data will be filtered by this property

        filterValue is required if filterBy is defined.

        Acceptable values are:
            'appId', 'deviceId', 'incidentId', 'verdict'

    .PARAMETER filterValue
        Data will be filtered by this property value

        filterBy is required if filterValue is defined.

    .PARAMETER sortBy
        Data will be sorted by this property.

        Acceptable values are:
            'appId', 'deviceId', 'incidentId', 'verdict', 'detectionDate', 'createdDate'

        The default value is 'detectionDate'

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
                "app_id": 1,
                "device_id": null,
                "verdict": 3,
                "detection_date": "2001-12-12T22:52:59.000Z",
                "value": "Ohio, US",
                "value_type": "SignInLocation",
                "details": {
                    "type": "signin",
                    "source": "source",
                    "msgraph": {
                    "correlationId": "id1234"
                    },
                    "priority": 1,
                    "attributes": {
                    "user": {
                        "name": "John Doe",
                        "loginAttempt": "Failure",
                        "principalName": "jdhardee@example.com"
                    },
                    "location": {
                        "city": "London",
                        "state": "Ohio",
                        "source": "",
                        "latitude": 4.91006,
                        "longitude": 111.0802,
                        "ip_address": "192.168.0.254",
                        "threatsFound": [],
                        "countryOrRegion": "US"
                    },
                    "device_detail": {
                        "browser": "",
                        "appDisplayName": "Office 365 Exchange Online",
                        "operatingSystem": ""
                    },
                    "threat_detail": {
                        "riskState": "none",
                        "detections": 0,
                        "riskDetail": "none",
                        "riskLevelAggregated": "none",
                        "riskLevelDuringSignIn": "none",
                        "conditionalAccessStatus": "notApplied",
                        "appliedConditionalAccessPolicies": []
                    }
                    }
                },
                "created_at": "2001-12-12T23:05:46.508Z",
                "updated_at": "2001-12-12T23:05:46.508Z",
                "customer_id": 123456,
                "account_path": "1234.5678",
                "incident_id": 654321
                }
            ]
        }

    .EXAMPLE
        Get-RocketCyberEvents -id 12345

        Gets the first 1000 events for account id 12345. Data is sorted by detectionDate and returned in descending order.

    .EXAMPLE
        Get-RocketCyberEvents -id 12345 -sortBy appId -orderBy asc

        Gets the first 1000 events for account id 12345. Data is sorted by appId and returned in ascending order.

    .EXAMPLE
        Get-RocketCyberEvents -id 12345 -filterBy appId -filterValue 10

        Gets the first 1000 events from appId 10, for account id 12345. Data is sorted by detectionDate and returned in descending order.

        appId 10 = ACTIVE DIRECTORY MONITOR AND SYNC

    .EXAMPLE
        Get-RocketCyberEvents -id 12345 -startDate '2022-03-17 13:00' -endDate '2022-03-18 13:00'

        Gets the first 1000 events between 2022-03-17 13:00 & 2022-03-18 13:00 for account id 12345.
        Data is sorted by detectionDate and returned in descending order.

        The inputted Date\Time is converted to UTC time.
            2022-03-17 13:00 = 2022-03-17T19:00:00.000Z
            2022-03-18 13:00 = 2022-03-18T19:00:00.000Z

    .EXAMPLE
        Get-RocketCyberEvents -id 12345 -startDate '2022-03-17 13:00'

        Gets the first 1000 events for account id 12345 between 2022-03-17 13:00 & the present date.
        Data is sorted by detectionDate and returned in descending order.

        The inputted Date\Time is converted to UTC time.
            2022-03-17 13:00 = 2022-03-17T19:00:00.000Z
            2022-03-18 13:00 = 2022-03-18T19:00:00.000Z

    .EXAMPLE
        Get-RocketCyberEvents -id 12345 -pageNumber 2 -pageSize 100

        Gets the first 100 events for account id 12345. Data is returned 100 at a time and shown starting on page 2.
        Data is sorted by detectionDate and returned in descending order.

    .NOTES
        2022-03 - In some cases when setting the page size lower then 100 causes the API to return an HTML Application Error
        Look into a better startDate & endDate handling method
        Look into a better sortBy & orderBy handling method

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
        [ValidateSet( 'appId', 'deviceId', 'incidentId', 'verdict' )]
        [string]$filterBy,

        [Parameter(ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$filterValue,

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet( 'appId', 'deviceId', 'incidentId', 'verdict', 'detectionDate', 'createdDate' )]
        [string]$sortBy = 'detectionDate',

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

    $resource_uri = "/$id/events"

    $body = @{}

    if ($PSCmdlet.ParameterSetName -eq 'index') {

        if ($startDate){
            $body += @{'startDate' = ($startDate).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")}
        }

        if ($endDate){
            $body += @{'endDate' = ($endDate).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")}
        }

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
