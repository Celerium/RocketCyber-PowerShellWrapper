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

    [CmdletBinding()]
    [alias("Get-RCAPIKey")]
    Param (
        [Parameter( Mandatory = $false) ]
        [Switch]$plainText
    )

    begin {}

    process{

        try {

            if ($RocketCyber_API_Key){
                if ($PlainText){
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($RocketCyber_API_Key)
                    ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) ).ToString()
                }
                else{$RocketCyber_API_Key}
            }
            else{
                Write-Warning 'The RocketCyber API key is not set. Run Add-RocketCyberAPIKey to set the API key.'
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

    end{}

}