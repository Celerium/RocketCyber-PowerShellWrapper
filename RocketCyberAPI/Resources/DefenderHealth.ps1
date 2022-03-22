function Get-RocketCyberDefenderHealth {
<#
    .SYNOPSIS
        Gets defender health information for a given account ID from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberDefenderHealth cmdlet gets defender health information for a given account ID from the RocketCyber API.

    .PARAMETER id
        Data will be retrieved from this account id.

    .EXAMPLE
        Example Response Body:

        {
            "totalDevices": 17,
            "totalHealthy": 6,
            "totalUnhealthy": 1,
            "totalUnknown": 10
        }

    .EXAMPLE
        Get-RocketCyberDefenderHealth -id 12345

        Defender health data will be retrieved from account 12345.

    .EXAMPLE
        12345 | Get-RocketCyberDefenderHealth

        Defender health data will be retrieved from account 12345.

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

    $resource_uri = "/$id/defender/health"

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
