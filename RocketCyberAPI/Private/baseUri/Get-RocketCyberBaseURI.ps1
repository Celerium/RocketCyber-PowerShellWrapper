function Get-RocketCyberBaseURI {
<#
    .SYNOPSIS
        Shows the RocketCyber base URI global variable.

    .DESCRIPTION
        The Get-RocketCyberBaseURI cmdlet shows the RocketCyber base URI global variable value.

    .EXAMPLE
        Get-RocketCyberBaseURI

        Shows the RocketCyber base URI global variable value.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberBaseURI.html
#>

    [CmdletBinding()]
    [alias("Get-RCBaseURI")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyber_Base_URI) {
            $true   { $RocketCyber_Base_URI }
            $false  { Write-Warning "The RocketCyber base URI is not set. Run Add-RocketCyberBaseURI to set the base URI." }
        }

    }

    end {}
}