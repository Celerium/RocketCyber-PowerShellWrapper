function Get-RocketCyberApps {
<#
    .SYNOPSIS
        Gets an accounts apps from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberApps cmdlet gets an accounts apps
        from the RocketCyber API.

        Can be used with the Get-RocketCyberEvents cmdlet

    .PARAMETER accountId
        The account ID to pull data for.

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

    .PARAMETER status
        The type of apps to request

        Acceptable values are:
            'active', 'inactive'

        The default value is 'active'

    .EXAMPLE
        Get-RocketCyberApps

        Gets active apps from accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberApps -accountId 12345

        Gets active apps from account 12345.

    .EXAMPLE
        Get-RocketCyberApps -accountId 12345 -status inactive

        Gets inactive apps from account 12345.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Apps/Get-RocketCyberApps.html

#>

[CmdletBinding(DefaultParameterSetName = 'index')]
Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$accountId,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [ValidateSet( 'active', 'inactive' )]
        [String]$status
)

begin{ $resource_Uri = '/apps' }

process{

    Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

    Set-Variable -Name 'RocketCyber_appParameters' -Value $PSBoundParameters -Scope Global -Force

    Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

}

end{}

}