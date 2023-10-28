---
external help file: RocketCyberAPI-help.xml
grand_parent: Internal
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Export-RocketCyberModuleSettings.html
parent: GET
schema: 2.0.0
title: Export-RocketCyberModuleSettings
---

# Export-RocketCyberModuleSettings

## SYNOPSIS
Exports the RocketCyber BaseURI, API, & JSON configuration information to file.

## SYNTAX

```powershell
Export-RocketCyberModuleSettings [-RocketCyberConfPath <String>] [-RocketCyberConfFile <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Export-RocketCyberModuleSettings cmdlet exports the RocketCyber BaseURI, API, & JSON configuration information to file.

Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
This means that you cannot copy your configuration file to another computer or user account and expect it to work.

## EXAMPLES

### EXAMPLE 1
```powershell
Export-RocketCyberModuleSettings
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's RocketCyber configuration file located at:
    $env:USERPROFILE\RocketCyberAPI\config.psd1

### EXAMPLE 2
```powershell
Export-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -RocketCyberConfFile MyConfig.psd1
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's RocketCyber configuration file located at:
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Export-RocketCyberModuleSettings.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Export-RocketCyberModuleSettings.html)

