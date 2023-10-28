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

    [CmdletBinding(SupportsShouldProcess)]
    [alias("Remove-RCAPIKey")]
    Param ()

    begin {}

    process{

        if ($RocketCyber_API_Key) {
            Remove-Variable -Name 'RocketCyber_API_Key' -Scope Global -Force
        }
        else{
            Write-Warning "The RocketCyber API key variable is not set. Nothing to remove"
        }

    }

    end{}

}