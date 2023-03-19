---
external help file: RocketCyberAPI-help.xml
grand_parent: Internal
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Import-RocketCyberModuleSettings.html
parent: GET
schema: 2.0.0
title: Import-RocketCyberModuleSettings
---

# Import-RocketCyberModuleSettings

## SYNOPSIS
Imports the RocketCyber BaseURI, API, & JSON configuration information to the current session.

## SYNTAX

```powershell
Import-RocketCyberModuleSettings [-RocketCyberConfPath <String>] [-RocketCyberConfFile <String>]
 [<CommonParameters>]
```

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

### -RocketCyberConfPath
Define the location to store the RocketCyber configuration file.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\RocketCyberAPI

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "$($env:USERPROFILE)\RocketCyberAPI"
Accept pipeline input: False
Accept wildcard characters: False
```

### -RocketCyberConfFile
Define the name of the RocketCyber configuration file.

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Import-RocketCyberModuleSettings.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Import-RocketCyberModuleSettings.html)

