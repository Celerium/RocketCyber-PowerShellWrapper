---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Export-RCModuleSettings.html
parent: Special
schema: 2.0.0
title: Export-RCModuleSettings
---

# Export-RCModuleSettings

## SYNOPSIS
Gets the saved RocketCyber configuration settings

## SYNTAX

## DESCRIPTION
The Get-RocketCyberModuleSettings cmdlet gets the saved RocketCyber configuration settings

By default the configuration file is stored in the following location:
    $env:USERPROFILE\RocketCyberAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberModuleSettings
```

Gets the contents of the configuration file that was created with the
Export-RocketCyberModuleSettings

The default location of the RocketCyber configuration file is:
    $env:USERPROFILE\RocketCyberAPI\config.psd1

### EXAMPLE 2
```powershell
Get-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -RocketCyberConfFile MyConfig.psd1 -openConfFile
```

Opens the configuration file from the defined location in the default editor

The location of the RocketCyber configuration file in this example is:
    C:\RocketCyberAPI\MyConfig.psd1

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberModuleSettings.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberModuleSettings.html)

