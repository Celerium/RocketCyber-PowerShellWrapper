function Get-RocketCyberDefender {
<#
    .SYNOPSIS
        Gets defender information from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberDefender cmdlet gets an accounts defender information
        from the RocketCyber API.

        This includes various health & risk values

    .PARAMETER accountId
        The account ID to pull data for.

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

    .EXAMPLE
        Get-RocketCyberDefender

        Gets defender information all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberDefender -accountId 12345

        Gets defender information from account 12345

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Defender/Get-RocketCyberDefender.html

#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Get-RCDefender")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$accountId
    )

    begin{ $resource_Uri = '/defender' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'RocketCyber_defenderParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}