function Remove-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Removes the stored RocketCyber configuration folder.

    .DESCRIPTION
        The Remove-RocketCyberModuleSettings cmdlet removes the RocketCyber folder and its files.
        This cmdlet also has the option to remove sensitive RocketCyber variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfPath
        Define the location of the RocketCyber configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER AndVariables
        Define if sensitive RocketCyber variables should be removed as well.

        By default the variables are not removed.

    .EXAMPLE
        Remove-RocketCyberModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the RocketCyber configuration folder is:
            $env:USERPROFILE\RocketCyberAPI

    .EXAMPLE
        Remove-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive RocketCyber variables exist then they are removed as well.

        The location of the RocketCyber configuration folder in this example is:
            C:\RocketCyberAPI

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Remove-RocketCyberModuleSettings.html
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    [alias("Remove-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"RocketCyberAPI"}else{".RocketCyberAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    begin {}

    process {

        if(Test-Path $RocketCyberConfPath)  {

            Remove-Item -Path $RocketCyberConfPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($AndVariables) {
                Remove-RocketCyberAPIKey
                Remove-RocketCyberBaseURI
            }

            if ($WhatIfPreference -eq $false){

                if (!(Test-Path $RocketCyberConfPath)) {
                    Write-Output "The RocketCyberAPI configuration folder has been removed successfully from [ $RocketCyberConfPath ]"
                }
                else {
                    Write-Error "The RocketCyberAPI configuration folder could not be removed from [ $RocketCyberConfPath ]"
                }

            }

        }
        else {
            Write-Warning "No configuration folder found at [ $RocketCyberConfPath ]"
        }

    }

    end {}

}