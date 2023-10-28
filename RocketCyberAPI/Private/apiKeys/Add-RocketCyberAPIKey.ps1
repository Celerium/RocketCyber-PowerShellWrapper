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

    [CmdletBinding()]
    [alias( "Add-RCAPIKey", "Set-RCAPIKey", "Set-RocketCyberAPIKey" )]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [Alias('ApiKey')]
        [string]$Api_Key
    )

    begin {}

    process{

        if ($Api_Key) {
            $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

            Set-Variable -Name 'RocketCyber_API_Key' -Value $x_api_key -Option ReadOnly -Scope Global -Force
        }
        else {
            $x_api_key = Read-Host -Prompt 'Please enter your API key' -AsSecureString

            Set-Variable -Name 'RocketCyber_API_Key' -Value $x_api_key -Option ReadOnly -Scope Global -Force
        }

    }

    end {}
}