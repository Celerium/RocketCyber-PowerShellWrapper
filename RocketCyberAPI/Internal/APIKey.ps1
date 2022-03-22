function Add-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Sets your API access token used to authenticate all API calls.

    .DESCRIPTION
        The Add-RocketCyberAPIKey cmdlet sets your API access token which is used to authenticate all API calls made to RocketCyber.
        Once the API access token is defined by Add-RocketCyberAPIKey, it is encrypted using SecureString.

        The RocketCyber API access tokens are generated via the RocketCyber web interface at Provider Settings > RocketCyber API

    .PARAMETER Api_Key
        Define your API access token that was generated from RocketCyber.

    .EXAMPLE
        Add-RocketCyberAPIKey

        Prompts to enter in the API access token

    .EXAMPLE
        Add-RocketCyberAPIKey -Api_key 'your_api_key'

        The RocketCyber API will use the string entered into the [ -Api_Key ] parameter.

    .EXAMPLE
        '12345' | Add-RocketCyberAPIKey

        The Add-RocketCyberAPIKey function will use the string passed into it as its API access token.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/RocketCyber-PowerShellWrapper
        https://api-doc.rocketcyber.com/
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [Alias('ApiKey')]
        [string]$Api_Key
    )

    if ($Api_Key) {
        $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

        Set-Variable -Name "RocketCyber_API_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
    else {
        Write-Output "Please enter your API key:"
        $x_api_key = Read-Host -AsSecureString

        Set-Variable -Name "RocketCyber_API_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
}

function Get-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Gets the RocketCyber API access token global variable.

    .DESCRIPTION
        The Get-RocketCyberAPIKey cmdlet gets the RocketCyber API access token global variable and
        returns it as a SecureString.

    .EXAMPLE
        Get-RocketCyberAPIKey

        Gets the RocketCyber API access token global variable and returns it as a SecureString.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/RocketCyber-PowerShellWrapper
        https://api-doc.rocketcyber.com/
#>

    [cmdletbinding()]
    Param ()

    if ($RocketCyber_API_Key){
        $RocketCyber_API_Key
    }
    Else{
        Write-Warning "The RocketCyber API access token is not set. Run Add-RocketCyberAPIKey to set the API access token."
    }
}

function Remove-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Removes the RocketCyber API access token global variable.

    .DESCRIPTION
        The Remove-RocketCyberAPIKey cmdlet removes the RocketCyber API access token global variable.

    .EXAMPLE
        Remove-RocketCyberAPIKey

        Removes the RocketCyber API access token global variable.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/RocketCyber-PowerShellWrapper
        https://api-doc.rocketcyber.com/
#>

    [cmdletbinding()]
    Param ()

    if ($RocketCyber_API_Key) {
        Remove-Variable -Name "RocketCyber_API_Key" -Scope global -Force
    }
    Else{
        Write-Warning "The RocketCyber API access token variable is not set. Nothing to remove"
    }
}

function Test-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Test the RocketCyber API access token.

    .DESCRIPTION
        The Test-RocketCyberAPIKey cmdlet tests the base URI & API access token that was defined in the
        Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

    .PARAMETER base_uri
        Define the base URI for the RocketCyber API connection using RocketCyber's URI or a custom URI.

        The default base URI is https://api-us.rocketcyber.com/v2/account

    .PARAMETER id
        Data will be retrieved from this account id.

    .EXAMPLE
        Test-RocketCyberBaseURI -id 12345

        Tests the base URI & API access token that was defined in the
        Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

        The default full base uri test path is:
            https://api-us.rocketcyber.com/v2/account/id

    .EXAMPLE
        Test-RocketCyberBaseURI -base_uri http://myapi.gateway.example.com -id 12345

        Tests the base URI & API access token that was defined in the
        Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/id

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/RocketCyber-PowerShellWrapper
        https://api-doc.rocketcyber.com/
#>

    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline = $true)]
        [string]$base_uri = $RocketCyber_Base_URI,

        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Int64]$id
    )

    $resource_uri = "/$id"

    try {
        if ($null -eq $RocketCyber_API_Key) {
            throw "The RocketCyber API access token is not set. Run Add-RocketCyberAPIKey to set the API access token."
        }

        $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($RocketCyber_API_Key)
        $Bearer_Token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key)
        $RocketCyber_Headers.Add('Authorization', "Bearer $Bearer_Token")

        $rest_output = Invoke-WebRequest -method 'GET' -uri ($base_uri + $resource_uri) -headers $RocketCyber_Headers -ErrorAction Stop
    }
    catch {

        [PSCustomObject]@{
            Method = $_.Exception.Response.Method
            StatusCode = $_.Exception.Response.StatusCode.value__
            StatusDescription = $_.Exception.Response.StatusDescription
            Message = $_.Exception.Message
            URI = $($RocketCyber_Base_URI + $resource_uri)
        }

    } finally {
        [void] ($RocketCyber_Headers.Remove('Authorization'))
        if ($Api_Key) {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
        }
    }

    if ($rest_output){
        $data = @{}
        $data = $rest_output

        [PSCustomObject]@{
            StatusCode = $data.StatusCode
            StatusDescription = $data.StatusDescription
            URI = $($RocketCyber_Base_URI + $resource_uri)
        }
    }
}


New-Alias -Name Set-RocketCyberAPIKey -Value Add-RocketCyberAPIKey -Force
