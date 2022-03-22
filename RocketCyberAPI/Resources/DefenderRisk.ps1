function Get-RocketCyberDefenderRisk {
<#
    .SYNOPSIS
        Gets defender risk information for a given account ID from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberDefenderRisk cmdlet gets defender risk information for a given account ID from the RocketCyber API.

    .PARAMETER id
        Data will be retrieved from this account id.

    .EXAMPLE
        Example Response Body:

        {
            "detectionSummary": {
                "totalEvents": 30,
                "totalMalicious": 14,
                "totalSuspicious": 10,
                "totalInformational": 0
            },
            "devicesAtRisk": {
                "total": 2,
                "data": [
                    {
                        "hostname": "DESKTOP-AT67V98",
                        "ipAddress": "23.778.24.3",
                        "operatingSystem": {
                        "platform": "Microsoft",
                        "family": "Windows",
                        "version": "10",
                        "edition": "Pro"
                        },
                        "detections": {
                        "malicious": 1,
                        "suspicious": 3,
                        "informational": 0
                        }
                    }
                ]
            },
            "devicesWithPoorHealth": {
                "total": 1,
                "data": [
                    {
                        "hostname": "DESKTOP-AT67V98",
                        "ipAddress": "23.778.24.3",
                        "operatingSystem": {
                        "platform": "Microsoft",
                        "family": "Windows",
                        "version": "10",
                        "edition": "Pro"
                        }
                    }
                ]
            },
            "devicesWithUnknownHealth": {
                "total": 3,
                "data": [
                    {
                        "hostname": "ip-56-1-9-331.ec5",
                        "ipAddress": "11.0.3.11",
                        "operatingSystem": {
                        "platform": null,
                        "family": "Red Hat Enterprise Linux",
                        "version": "8.4 (Ootpa)",
                        "edition": null
                        }
                    }
                ]
            }
        }

    .EXAMPLE
        Get-RocketCyberDefenderRisk -id 12345

        Defender risk data will be retrieved from account 12345.


    .EXAMPLE
        12345 | Get-RocketCyberDefenderRisk

        Defender risk data will be retrieved from account 12345.

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

    $resource_uri = "/$id/defender/risk"

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
