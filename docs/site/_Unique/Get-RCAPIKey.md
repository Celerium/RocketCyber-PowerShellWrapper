---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Get-RCAPIKey.html
parent: Special
schema: 2.0.0
title: Get-RCAPIKey
---

# Get-RCAPIKey

## SYNOPSIS
Gets the RocketCyber API bearer token global variable.

## SYNTAX

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberAPIKey.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberAPIKey.html)

