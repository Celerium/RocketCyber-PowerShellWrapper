function Get-RocketCyberAccount {
<#
    .SYNOPSIS
        Gets account information for a given ID from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberAccount cmdlet gets account information for a given ID from the RocketCyber API.

    .PARAMETER id
        Data will be retrieved from this account id.

    .EXAMPLE
        Example Response Body:

        {
            "name": "John Watson & Co",
            "hierarchy": "Sherlock Holmes -> Dr. John Watson",
            "path": "2.1",
            "customers": [
                12343,
                12564,
                76565
            ],
            "address": {
                "street1": "Baker Street",
                "street2": "221B",
                "city": "London",
                "state": "Ohio",
                "country": "United States",
                "zipCode": "54321"
            },
            "type": "Customer",
            "status": "Active",
            "emails": "holmes@gmail.com,watson@gmail.com"
        }

    .EXAMPLE
        Get-RocketCyberAccount -id 12345

        Account data will be retrieved for the account with the id 12345.

    .EXAMPLE
        12345 | Get-RocketCyberAccount

        Account data will be retrieved for the account with the id 12345.

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

    $resource_uri = "/$id"

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
