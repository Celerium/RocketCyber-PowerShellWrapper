<#
    .SYNOPSIS
        Pester tests for functions in the "APIKey.ps1" file

    .DESCRIPTION
        Pester tests for functions in the APIKey.ps1 file which
        is apart of the RocketCyberAPI module.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\APIKey.Tests.ps1

        Runs a pester test against "APIKey.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\APIKey.Tests.ps1 -Output Detailed

        Runs a pester test against "APIKey.Tests.ps1" and outputs detailed test results.

    .NOTES
        Build out more robust, logical, & scalable pester tests.
        Look into BeforeAll as it is not working as expected with this test

    .LINK
        https://github.com/Celerium/RocketCyber-PowerShellWrapper
#>

#Requires -Version 5.0
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }
#Requires -Modules @{ ModuleName='RocketCyberAPI'; ModuleVersion='2.0.0' }

# General variables
    $FullFileName = $MyInvocation.MyCommand.Name
    #$ThisFile = $PSCommandPath -replace '\.Tests\.ps1$'
    #$ThisFileName = $ThisFile | Split-Path -Leaf


Describe "Testing [ *-RocketCyberAPIKey ] functions with [ $FullFileName ]" {

    Context "[ Add-RocketCyberAPIKey ] testing functions" {

        It "The RocketCyber_API_Key variable should initially be empty or null" {
            $RocketCyber_API_Key | Should -BeNullOrEmpty
        }

        It "[ Add-RocketCyberAPIKey ] should accept a value from the pipeline" {
            "RCAPIKEY" | Add-RocketCyberAPIKey
            Get-RocketCyberAPIKey | Should -Not -BeNullOrEmpty
        }

        It "[ Add-RocketCyberAPIKey ] called with parameter -API_Key should not be empty" {
            Add-RocketCyberAPIKey -Api_Key "RCAPIKEY"
            Get-RocketCyberAPIKey | Should -Not -BeNullOrEmpty
        }
    }

    Context "[ Get-RocketCyberAPIKey ] testing functions" {

        It "[ Get-RocketCyberAPIKey ] should return a value" {
            Get-RocketCyberAPIKey | Should -Not -BeNullOrEmpty
        }

        It "[ Get-RocketCyberAPIKey ] should be a SecureString (From PipeLine)" {
            "RCAPIKEY" | Add-RocketCyberAPIKey
            Get-RocketCyberAPIKey | Should -BeOfType SecureString
        }

        It "[ Get-RocketCyberAPIKey ] should be a SecureString (With Parameter)" {
            Add-RocketCyberAPIKey -Api_Key "RCAPIKEY"
            Get-RocketCyberAPIKey | Should -BeOfType SecureString
        }
    }

    Context "[ Remove-RocketCyberAPIKey ] testing functions" {

        It "[ Remove-RocketCyberAPIKey ] should remove the RocketCyber_API_Key variable" {
            Add-RocketCyberAPIKey -Api_Key "RCAPIKEY"
            Remove-RocketCyberAPIKey
            $RocketCyber_API_Key | Should -BeNullOrEmpty
        }
    }

    Context "[ Test-RocketCyberAPIKey ] testing functions" {

        It "[ Test-RocketCyberAPIKey ] without an API key should fail to authenticate" {
            Add-RocketCyberAPIKey -Api_Key "RCAPIKEY"
            Remove-RocketCyberAPIKey
            $Value = Test-RocketCyberAPIKey
            $Value.Message | Should -BeLike '*(401) Unauthorized*'
        }
    }

}