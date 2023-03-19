function Get-RocketCyberOffice {
<#
    .SYNOPSIS
        Gets office information from the RocketCyber API

    .DESCRIPTION
        The Get-RocketCyberOffice cmdlet gets office information
        from all or a defined accountId.

    .PARAMETER accountId
        The account ID to pull data for.

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

    .EXAMPLE
        Get-RocketCyberOffice

        Office data will be retrieved from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberOffice -accountId 12345

        Office data will be retrieved from the accountId 12345

    .EXAMPLE
        12345 | Get-RocketCyberOffice

        Office data will be retrieved from the accountId 12345

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Office/Get-RocketCyberOffice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
            [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'index')]
            [ValidateRange(1, [int64]::MaxValue)]
            [Int64]$accountId

    )

    begin{ $resource_Uri = '/office' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'RocketCyber_officeParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
