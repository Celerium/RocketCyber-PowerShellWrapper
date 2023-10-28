---
external help file: RocketCyberAPI-help.xml
grand_parent: Internal
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberAPIKey.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberAPIKey
---

# Get-RocketCyberAPIKey

## SYNOPSIS
Gets the RocketCyber API bearer token global variable.

## SYNTAX

```powershell
Get-RocketCyberAPIKey [-plainText] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberAPIKey cmdlet gets the RocketCyber API bearer token
global variable and returns it as a SecureString.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberAPIKey
```

Gets the RocketCyber API bearer token global variable and
returns it as a SecureString.

### EXAMPLE 2
```powershell
Get-RocketCyberAPIKey -PlainText
```

Gets and decrypts the API key from the global variable and
returns the API key in plain text

## PARAMETERS

### -plainText
Decrypt and return the API key in plain text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberAPIKey.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberAPIKey.html)

