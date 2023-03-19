function Add-RocketCyberBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the RocketCyber API connection.

    .DESCRIPTION
        The Add-RocketCyberBaseURI cmdlet sets the base URI which is later used
        to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the RocketCyber API connection using
        RocketCyber's URI or a custom URI.

    .PARAMETER data_center
        RocketCyber's URI connection point that can be one of the predefined data centers.

        The accepted values for this parameter are:
        [ US, EU ]
        US = https://api-us.rocketcyber.com/v3
        EU = https://api-eu.rocketcyber.com/v3

    .EXAMPLE
        Add-RocketCyberBaseURI

        The base URI will use https://api-us.rocketcyber.com/v3 which is RocketCyber's default URI.

    .EXAMPLE
        Add-RocketCyberBaseURI -data_center EU

        The base URI will use https://api-eu.rocketcyber.com/v3 which is RocketCyber's Europe URI.

    .EXAMPLE
        Add-RocketCyberBaseURI -base_uri http://myapi.gateway.example.com

        A custom API gateway of http://myapi.gateway.example.com will be used for
        all API calls to RocketCyber's API.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberBaseURI.html
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$base_uri = 'https://api-us.rocketcyber.com/v3',

        [Parameter(Mandatory = $false)]
        [ValidateSet( 'US', 'EU' )]
        [String]$data_center
    )

    process{

        # Trim superfluous forward slash from address (if applicable)
        if ($base_uri[$base_uri.Length-1] -eq "/") {
            $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
        }

        switch ($data_center) {
            'US' { $base_uri = "https://api-us.rocketcyber.com/v3" }
            'EU' { $base_uri = "https://api-eu.rocketcyber.com/v3" }
            Default {}
        }

        Set-Variable -Name 'RocketCyber_Base_URI' -Value $base_uri -Option ReadOnly -Scope global -Force

    }
}



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

    [cmdletbinding()]
    Param ()

    if ($RocketCyber_Base_URI){
        $RocketCyber_Base_URI
    }
    Else{
        Write-Warning "The RocketCyber base URI is not set. Run Add-RocketCyberBaseURI to set the base URI."
    }
}



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

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    if ($RocketCyber_Base_URI) {
        Remove-Variable -Name "RocketCyber_Base_URI" -Scope global -Force -WhatIf:$WhatIfPreference
    }
    Else{
        Write-Warning "The RocketCyber base URI variable is not set. Nothing to remove"
    }
}



New-Alias -Name Set-RocketCyberBaseURI -Value Add-RocketCyberBaseURI