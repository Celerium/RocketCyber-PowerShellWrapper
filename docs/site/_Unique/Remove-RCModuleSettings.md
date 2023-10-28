---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Remove-RCModuleSettings.html
parent: Special
schema: 2.0.0
title: Remove-RCModuleSettings
---

# Remove-RCModuleSettings

## SYNOPSIS
Removes the stored RocketCyber configuration folder.

## SYNTAX

## DESCRIPTION
The Remove-RocketCyberModuleSettings cmdlet removes the RocketCyber folder and its files.
This cmdlet also has the option to remove sensitive RocketCyber variables as well.

By default configuration files are stored in the following location and will be removed:
    $env:USERPROFILE\RocketCyberAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-RocketCyberModuleSettings
```

Checks to see if the default configuration folder exists and removes it if it does.

The default location of the RocketCyber configuration folder is:
    $env:USERPROFILE\RocketCyberAPI

### EXAMPLE 2
```powershell
Remove-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -AndVariables
```

Checks to see if the defined configuration folder exists and removes it if it does.
If sensitive RocketCyber variables exist then they are removed as well.

The location of the RocketCyber configuration folder in this example is:
    C:\RocketCyberAPI

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Remove-RocketCyberModuleSettings.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Remove-RocketCyberModuleSettings.html)

