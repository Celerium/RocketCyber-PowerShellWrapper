function Get-RocketCyberOffice {
<#
    .SYNOPSIS
        Gets Office365 integration information for a given ID from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberOffice cmdlet gets Office365 integration information for a given ID from the RocketCyber API.

    .PARAMETER id
        Data will be retrieved from this account id.

    .EXAMPLE
        Example Response Body:

        {
            "secureScoreProgress": {
                "startDate": "2021-01-23T00:00:00.000Z",
                "endDate": "2021-01-25T00:00:00.000Z",
                "totalDays": 3,
                "minScore": 30,
                "maxScore": 50,
                "averageScore": 40,
                "data": [
                    {
                        "detectionDate": "2021-01-23T00:00:00.000Z",
                        "secureScorePercentage": 54.03
                    }
                ]
            },
            "monitoredAccounts": {
                "total": 3,
                "data": [
                    {
                        "id": "bob@abc-cde.com",
                        "mfaStatus": "unknown",
                        "licenses": [
                        "CTA"
                        ]
                    }
                ]
            },
            "secureScoreToDo": {
                "total": 3,
                "data": [
                    {
                        "maxScore": 50,
                        "control": "AdminMFAV2",
                        "description": "Requiring multi-factor authentication (MFA) for all  ....etc"
                        "remediation": "Set up Azure Multi-Factor Authentication policies to ....etc"
                    }
                ]
            }
        }

    .EXAMPLE
        Get-RocketCyberOffice -id 12345

        Office365 integration data will be retrieved from account id 12345.

    .EXAMPLE
        12345 | Get-RocketCyberOffice

        Office365 integration data will be retrieved from account id 12345.

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
            [Int64]$id
    )

    $resource_uri = "/$id/office"

    $body = @{}

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
