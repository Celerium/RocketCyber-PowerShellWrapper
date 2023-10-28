---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Import-RCModuleSettings.html
parent: Special
schema: 2.0.0
title: Import-RCModuleSettings
---

# Import-RCModuleSettings

## SYNOPSIS
Imports the RocketCyber BaseURI, API, & JSON configuration information to the current session.

## SYNTAX

## DESCRIPTION
The Import-RocketCyberModuleSettings cmdlet imports the RocketCyber BaseURI, API, & JSON configuration
information stored in the RocketCyber configuration file to the users current session.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\RocketCyberAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Import-RocketCyberModuleSettings
```

Validates that the configuration file created with the Export-RocketCyberModuleSettings cmdlet exists
then imports the stored data into the current users session.

The default location of the RocketCyber configuration file is:
    $env:USERPROFILE\RocketCyberAPI\config.psd1

### EXAMPLE 2
```powershell
Import-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -RocketCyberConfFile MyConfig.psd1
```

Validates that the configuration file created with the Export-RocketCyberModuleSettings cmdlet exists
then imports the stored data into the current users session.

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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Import-RocketCyberModuleSettings.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Import-RocketCyberModuleSettings.html)

