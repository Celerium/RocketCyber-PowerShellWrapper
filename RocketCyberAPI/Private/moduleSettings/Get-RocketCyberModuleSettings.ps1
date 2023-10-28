function Get-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Gets the saved RocketCyber configuration settings

    .DESCRIPTION
        The Get-RocketCyberModuleSettings cmdlet gets the saved RocketCyber configuration settings

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfPath
        Define the location to store the RocketCyber configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfFile
        Define the name of the RocketCyber configuration file.

        By default the configuration file is named:
            config.psd1

    .PARAMETER openConfFile
        Opens the RocketCyber configuration file

    .EXAMPLE
        Get-RocketCyberModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-RocketCyberModuleSettings

        The default location of the RocketCyber configuration file is:
            $env:USERPROFILE\RocketCyberAPI\config.psd1

    .EXAMPLE
        Get-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -RocketCyberConfFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the RocketCyber configuration file in this example is:
            C:\RocketCyberAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Export-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$RocketCyberConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"RocketCyberAPI"}else{".RocketCyberAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$RocketCyberConfFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'show')]
        [Switch]$openConfFile
    )

    begin{
        $RocketCyberConfig = Join-Path -Path $RocketCyberConfPath -ChildPath $RocketCyberConfFile
    }

    process{

        if ( Test-Path -Path $RocketCyberConfig ) {

            if($openConfFile){
                Invoke-Item -Path $RocketCyberConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $RocketCyberConfPath -FileName $RocketCyberConfFile
            }

        }
        else {
            Write-Verbose "No configuration file found at [ $RocketCyberConfig ]"
        }

    }

    end{}

}