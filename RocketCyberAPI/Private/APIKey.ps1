function Add-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Sets your API bearer token used to authenticate all API calls.

    .DESCRIPTION
        The Add-RocketCyberAPIKey cmdlet sets your API bearer token which is used to
        authenticate all API calls made to RocketCyber. Once the API bearer token is
        defined, it is encrypted using SecureString.

        The RocketCyber API bearer tokens are generated via the RocketCyber web interface
        at Provider Settings > RocketCyber API

    .PARAMETER Api_Key
        Define your API bearer token that was generated from RocketCyber.

    .EXAMPLE
        Add-RocketCyberAPIKey

        Prompts to enter in the API bearer token

    .EXAMPLE
        Add-RocketCyberAPIKey -Api_key 'your_api_key'

        The RocketCyber API will use the string entered into the [ -Api_Key ] parameter.

    .EXAMPLE
        '12345' | Add-RocketCyberAPIKey

        The Add-RocketCyberAPIKey function will use the string passed into it as its API bearer token.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberAPIKey.html
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [Alias('ApiKey')]
        [string]$Api_Key
    )

    process{

        if ($Api_Key) {
            $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

            Set-Variable -Name 'RocketCyber_API_Key' -Value $x_api_key -Option ReadOnly -Scope global -Force
        }
        else {
            Write-Output 'Please enter your API key:'
            $x_api_key = Read-Host -AsSecureString

            Set-Variable -Name 'RocketCyber_API_Key' -Value $x_api_key -Option ReadOnly -Scope global -Force
        }

    }

}



function Get-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Gets the RocketCyber API bearer token global variable.

    .DESCRIPTION
        The Get-RocketCyberAPIKey cmdlet gets the RocketCyber API bearer token
        global variable and returns it as a SecureString.

    .PARAMETER PlainText
        Decrypt and return the API key in plain text.

    .EXAMPLE
        Get-RocketCyberAPIKey

        Gets the RocketCyber API bearer token global variable and
        returns it as a SecureString.

    .EXAMPLE
        Get-RocketCyberAPIKey -PlainText

        Gets and decrypts the API key from the global variable and
        returns the API key in plain text

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberAPIKey.html
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [Switch]$PlainText
    )

    try {
        if ($RocketCyber_API_Key){
            if ($PlainText){
                $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($RocketCyber_API_Key)
                ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) ).ToString()
                #Write-Output [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) -NoEnumerate
            }
            else{$RocketCyber_API_Key}
        }
        else{
            Write-Warning 'The RocketCyber bearer token is not set. Run Add-RocketCyberAPIKey to set the bearer token.'
        }
    }
    catch {
        Write-Error $_
    }
    finally {
        if ($Api_Key) {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
        }
    }

}



function Remove-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Removes the RocketCyber API bearer token global variable.

    .DESCRIPTION
        The Remove-RocketCyberAPIKey cmdlet removes the RocketCyber API
        bearer token global variable.

    .EXAMPLE
        Remove-RocketCyberAPIKey

        Removes the RocketCyber API bearer token global variable.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Remove-RocketCyberAPIKey.html
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    if ($RocketCyber_API_Key) {
        Remove-Variable -Name 'RocketCyber_API_Key' -Scope global -Force
    }
    Else{
        Write-Warning "The RocketCyber API bearer token variable is not set. Nothing to remove"
    }

}



function Test-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Test the RocketCyber API bearer token.

    .DESCRIPTION
        The Test-RocketCyberAPIKey cmdlet tests the base URI & API
        bearer token that was defined in the
        Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

    .PARAMETER base_uri
        Define the base URI for the RocketCyber API connection using RocketCyber's URI or a custom URI.

        The default base URI is https://api-us.rocketcyber.com/v3

    .PARAMETER id
        Data will be retrieved from this account id.

    .EXAMPLE
        Test-RocketCyberBaseURI -id 12345

        Tests the base URI & API bearer token that was defined in the
        Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

        The default full base uri test path is:
            https://api-us.rocketcyber.com/v2/account/id

    .EXAMPLE
        Test-RocketCyberBaseURI -base_uri http://myapi.gateway.example.com -id 12345

        Tests the base URI & API bearer token that was defined in the
        Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Test-RocketCyberAPIKey.html
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$base_uri = $RocketCyber_Base_URI
    )

    $resource_uri = "/account"

    Write-Verbose "Testing API key against [ $($base_uri + $resource_uri) ]"

    try {

        $Api_Token = Get-RocketCyberAPIKey -PlainText
        $RocketCyber_Headers.Add('Authorization', "Bearer $Api_Token")

        $rest_output = Invoke-WebRequest -Method Get -Uri ($base_uri + $resource_uri) -Headers $RocketCyber_Headers -ErrorAction Stop
    }
    catch {

        [PSCustomObject]@{
            Method = $_.Exception.Response.Method
            StatusCode = $_.Exception.Response.StatusCode.value__
            StatusDescription = $_.Exception.Response.StatusDescription
            Message = $_.Exception.Message
            URI = $($base_uri + $resource_uri)
        }

    } finally {
        [void] ($RocketCyber_Headers.Remove('Authorization'))
    }

    if ($rest_output){
        $data = @{}
        $data = $rest_output

        [PSCustomObject]@{
            StatusCode = $data.StatusCode
            StatusDescription = $data.StatusDescription
            URI = $($base_uri + $resource_uri)
        }
    }

}



New-Alias -Name Set-RocketCyberAPIKey -Value Add-RocketCyberAPIKey -Force
