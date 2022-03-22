<#
    .SYNOPSIS
        Pester tests for functions in the "BaseURI.ps1" file

    .DESCRIPTION
        Pester tests for functions in the "BaseURI.ps1" file which
        is apart of the RocketCyberAPI module.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1

        Runs a pester test against "BaseURI.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1 -Output Detailed

        Runs a pester test against "BaseURI.Tests.ps1" and outputs detailed test results.

    .NOTES
        Build out more robust, logical, & scalable pester tests.
        Look into BeforeAll as it is not working as expected with this test

    .LINK
        https://github.com/Celerium/RocketCyber-PowerShellWrapper
#>

#Requires -Version 5.0
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }
#Requires -Modules @{ ModuleName='RocketCyberAPI'; ModuleVersion='1.0.0' }

# General variables
    $FullFileName = $MyInvocation.MyCommand.Name
    #$ThisFile = $PSCommandPath -replace '\.Tests\.ps1$'
    #$ThisFileName = $ThisFile | Split-Path -Leaf


Describe " Testing [ *-RocketCyberBaseURI } functions with [ $FullFileName ]" {

    Context "[ Add-RocketCyberBaseURI ] testing functions" {

        It "[ Add-RocketCyberBaseURI ] without parameter should return a valid URI" {
            Add-RocketCyberBaseURI
            Get-RocketCyberBaseURI | Should -Be 'https://api-us.rocketcyber.com/v2/account'
        }

        It "[ Add-RocketCyberBaseURI ] should accept a value from the pipeline" {
            'https://celerium.org' | Add-RocketCyberBaseURI
            Get-RocketCyberBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-RocketCyberBaseURI ] with parameter -base_uri should return a valid URI" {
            Add-RocketCyberBaseURI -base_uri 'https://celerium.org'
            Get-RocketCyberBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-RocketCyberBaseURI ] with parameter -data_center US should return a valid URI" {
            Add-RocketCyberBaseURI -data_center 'US'
            Get-RocketCyberBaseURI | Should -Be 'https://api-us.rocketcyber.com/v2/account'
        }

        It "[ Add-RocketCyberBaseURI ] with parameter -data_center EU should return a valid URI" {
            Add-RocketCyberBaseURI -data_center 'EU'
            Get-RocketCyberBaseURI | Should -Be 'https://api-eu.rocketcyber.com/v2/account'
        }

        It "[ Add-RocketCyberBaseURI ] a trailing / from a base_uri should be removed" {
            Add-RocketCyberBaseURI -base_uri 'https://celerium.org/'
            Get-RocketCyberBaseURI | Should -Be 'https://celerium.org'
        }
    }

    Context "[ Get-RocketCyberBaseURI ] testing functions" {

        It "[ Get-RocketCyberBaseURI ] should return a valid URI" {
            Add-RocketCyberBaseURI
            Get-RocketCyberBaseURI | Should -Be 'https://api-us.rocketcyber.com/v2/account'
        }

        It "[ Get-RocketCyberBaseURI ] value should be a string" {
            Add-RocketCyberBaseURI
            Get-RocketCyberBaseURI | Should -BeOfType string
        }
    }

    Context "[ Remove-RocketCyberBaseURI ] testing functions" {

        It "[ Remove-RocketCyberBaseURI ] should remove the variable" {
            Add-RocketCyberBaseURI
            Remove-RocketCyberBaseURI
            $RocketCyber_Base_URI | Should -BeNullOrEmpty
        }
    }

}