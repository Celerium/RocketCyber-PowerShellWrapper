function Get-RocketCyberCustomers {
<#
    .SYNOPSIS
        Gets customer account information from a given parent ID.

    .DESCRIPTION
        The Get-RocketCyberCustomers cmdlet gets customer account information from a given parent ID.

    .PARAMETER id
        The parent account id to get associated customers from.

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
        Get-RocketCyberCustomers -id 12345

        Customer account data will be retrieved from the parent account with the id 12345.

    .EXAMPLE
        12345 | Get-RocketCyberCustomers

        Customer account data will be retrieved from the parent account with the id 12345.

    .NOTES
        This cmdlet is NOT an endpoint in the RocketCyber API at this time.
        I added this cmdlet to make it easier to get customer account data from a parent account.

        This cmdlet is using the same code from the Get-RocketCyberAccount cmdlet.

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

        if ($rest_output.customers) {
            $customer_output = ForEach ($Customer in $rest_output.customers){
                Invoke-RestMethod -method 'GET' -uri ( $RocketCyber_Base_URI + '/' + $Customer ) -headers $RocketCyber_Headers `
                -body $body -ErrorAction Stop -ErrorVariable web_error
            }
        }
        else {
            [PSCustomObject]@{
                Account = $rest_output.name
                AccountId = $id
                Message = "There are no customers associated with this account."
            }
        }

    } catch {
        Write-Error $_
    } finally {
        [void] ($RocketCyber_Headers.Remove('Authorization'))
        if ($Api_Key) {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
        }
    }

    $data = @{}
    $data = $customer_output
    return $data

}
