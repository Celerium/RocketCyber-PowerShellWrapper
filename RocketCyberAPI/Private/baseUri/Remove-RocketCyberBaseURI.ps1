function Remove-RocketCyberBaseURI {
<#
    .SYNOPSIS
        Removes the RocketCyber base URI global variable.

    .DESCRIPTION
        The Remove-RocketCyberBaseURI cmdlet removes the RocketCyber base URI global variable.

    .EXAMPLE
        Remove-RocketCyberBaseURI

        Removes the RocketCyber base URI global variable.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Remove-RocketCyberBaseURI.html
#>

    [CmdletBinding(SupportsShouldProcess)]
    [alias("Remove-RCBaseURI")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyber_Base_URI) {
            $true   { Remove-Variable -Name "RocketCyber_Base_URI" -Scope Global -Force }
            $false  { Write-Warning "The RocketCyber base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}