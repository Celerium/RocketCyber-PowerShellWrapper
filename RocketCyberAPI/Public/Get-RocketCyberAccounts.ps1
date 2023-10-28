function Get-RocketCyberAccounts {
<#
    .SYNOPSIS
        Gets account information for a given ID.

    .DESCRIPTION
        The Get-RocketCyberAccount cmdlet gets account information all
        accounts or for a given ID from the RocketCyber API.

    .PARAMETER accountId
        The account ID to pull data for.

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

    .PARAMETER details
        Should additional details for each sub-accounts be displayed
        in the return data.

    .EXAMPLE
        Get-RocketCyberAccount

        Account data will be retrieved from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberAccount -accountId 12345

        Account data will be retrieved for the account with the accountId 12345.

    .EXAMPLE
        12345 | Get-RocketCyberAccount

        Account data will be retrieved for the account with the accountId 12345.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Accounts/Get-RocketCyberAccount.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Get-RCAccounts")]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$accountId,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [Switch]$details

    )

    begin{ $resource_Uri = '/account' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'RocketCyber_accountParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
