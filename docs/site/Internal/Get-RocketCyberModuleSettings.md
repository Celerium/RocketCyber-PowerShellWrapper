---
external help file: RocketCyberAPI-help.xml
grand_parent: Internal
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberModuleSettings.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberModuleSettings
---

# Get-RocketCyberModuleSettings

## SYNOPSIS
Gets the saved RocketCyber configuration settings

## SYNTAX

### index (Default)
```powershell
Get-RocketCyberModuleSettings [-RocketCyberConfPath <String>] [-RocketCyberConfFile <String>]
 [<CommonParameters>]
```

### show
```powershell
Get-RocketCyberModuleSettings [-openConfFile] [<CommonParameters>]
```

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

### -RocketCyberConfPath
Define the location to store the RocketCyber configuration file.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\RocketCyberAPI

```yaml
Type: String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"RocketCyberAPI"}else{".RocketCyberAPI"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -RocketCyberConfFile
Define the name of the RocketCyber configuration file.

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### -openConfFile
Opens the RocketCyber configuration file

```yaml
Type: SwitchParameter
Parameter Sets: show
Aliases:

Required: False
Position: Named
Default value: False
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberModuleSettings.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberModuleSettings.html)

