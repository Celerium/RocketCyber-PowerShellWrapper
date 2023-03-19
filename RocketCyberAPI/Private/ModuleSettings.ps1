function Export-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Exports the RocketCyber BaseURI, API, & JSON configuration information to file.

    .DESCRIPTION
        The Export-RocketCyberModuleSettings cmdlet exports the RocketCyber BaseURI, API, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER RocketCyberConfPath
        Define the location to store the RocketCyber configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfFile
        Define the name of the RocketCyber configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-RocketCyberModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's RocketCyber configuration file located at:
            $env:USERPROFILE\RocketCyberAPI\config.psd1

    .EXAMPLE
        Export-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -RocketCyberConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's RocketCyber configuration file located at:
            C:\RocketCyberAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Export-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfPath = "$($env:USERPROFILE)\RocketCyberAPI",

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfFile = 'config.psd1'
    )

    # Confirm variables exist and are not null before exporting
    if ($RocketCyber_Base_URI -and $RocketCyber_API_Key -and $RocketCyber_JSON_Conversion_Depth) {
        $secureString = $RocketCyber_API_KEY | ConvertFrom-SecureString
        New-Item -Path $RocketCyberConfPath -ItemType Directory -Force | ForEach-Object {$_.Attributes = 'hidden'}
@"
    @{
        RocketCyber_Base_URI = '$RocketCyber_Base_URI'
        RocketCyber_API_Key = '$secureString'
        RocketCyber_JSON_Conversion_Depth = '$RocketCyber_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath ($RocketCyberConfPath+"\"+$RocketCyberConfFile) -Force

    }
    else {
        Write-Error "Failed to export RocketCyber Module settings to [ $RocketCyberConfPath\$RocketCyberConfFile ]"
    }
}



function Get-RocketCyberModuleSettings{
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
Param (
    [Parameter(Mandatory = $false, ParameterSetName = 'index')]
    [String]$RocketCyberConfPath = "$($env:USERPROFILE)\RocketCyberAPI",

    [Parameter(Mandatory = $false, ParameterSetName = 'index')]
    [String]$RocketCyberConfFile = 'config.psd1',

    [Parameter(Mandatory = $false, ParameterSetName = 'show')]
    [Switch]$openConfFile
)

begin{}

process{

    if ( Test-Path -Path $($RocketCyberConfPath + '\' + $RocketCyberConfFile) ){

        if($openConfFile){
            Invoke-Item -Path $($RocketCyberConfPath + '\' + $RocketCyberConfFile)
        }
        else{
            Import-LocalizedData -BaseDirectory $RocketCyberConfPath -FileName $RocketCyberConfFile
        }

    }
    else{
        Write-Verbose "No configuration file found at [ $RocketCyberConfPath\$RocketCyberConfFile ]"
    }

}

end{}

}



function Import-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Imports the RocketCyber BaseURI, API, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-RocketCyberModuleSettings cmdlet imports the RocketCyber BaseURI, API, & JSON configuration
        information stored in the RocketCyber configuration file to the users current session.

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

    .EXAMPLE
        Import-RocketCyberModuleSettings

        Validates that the configuration file created with the Export-RocketCyberModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The default location of the RocketCyber configuration file is:
            $env:USERPROFILE\RocketCyberAPI\config.psd1

    .EXAMPLE
        Import-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -RocketCyberConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-RocketCyberModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The location of the RocketCyber configuration file in this example is:
            C:\RocketCyberAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Import-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfPath = "$($env:USERPROFILE)\RocketCyberAPI",

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfFile = 'config.psd1'
    )

    if( test-path ($RocketCyberConfPath+"\"+$RocketCyberConfFile) ) {
        $tmp_config = Import-LocalizedData -BaseDirectory $RocketCyberConfPath -FileName $RocketCyberConfFile

            # Send to function to strip potentially superfluous slash (/)
            Add-RocketCyberBaseURI $tmp_config.RocketCyber_Base_URI

            $tmp_config.RocketCyber_API_key = ConvertTo-SecureString $tmp_config.RocketCyber_API_key

            Set-Variable -Name 'RocketCyber_Base_URI' -Value $tmp_config.RocketCyber_Base_URI -Option ReadOnly -Scope global -Force

            Set-Variable -Name 'RocketCyber_API_Key' -Value $tmp_config.RocketCyber_API_key -Option ReadOnly -Scope global -Force

            Set-Variable -Name 'RocketCyber_JSON_Conversion_Depth' -Value $tmp_config.RocketCyber_JSON_Conversion_Depth -Scope global -Force

        Write-Verbose "The RocketCyberAPI Module configuration loaded successfully from [ $RocketCyberConfPath\$RocketCyberConfFile ]"

        # Clean things up
        Remove-Variable "tmp_config"
    }
    else {
        Write-Verbose "No configuration file found at [ $RocketCyberConfPath\$RocketCyberConfFile ] run Add-RocketCyberAPIKey & Add-RocketCyberBaseURI to get started."

        Set-Variable -Name 'RocketCyber_JSON_Conversion_Depth' -Value 100 -Scope global -Force
    }
}



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
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfPath = "$($env:USERPROFILE)\RocketCyberAPI",

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    if(Test-Path $RocketCyberConfPath)  {

        Remove-Item -Path $RocketCyberConfPath -Recurse -Force -WhatIf:$WhatIfPreference

        If ($AndVariables) {
            if ($RocketCyber_API_Key) {
                Remove-Variable -Name "RocketCyber_API_Key" -Scope global -Force -WhatIf:$WhatIfPreference
            }
            if ($RocketCyber_Base_URI) {
                Remove-Variable -Name "RocketCyber_Base_URI" -Scope global -Force -WhatIf:$WhatIfPreference
            }
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