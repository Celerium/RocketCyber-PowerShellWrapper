---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Test-RCAPIKey.html
parent: Special
schema: 2.0.0
title: Test-RCAPIKey
---

# Test-RCAPIKey

## SYNOPSIS
Test the RocketCyber API bearer token.

## SYNTAX

## DESCRIPTION
The Test-RocketCyberAPIKey cmdlet tests the base URI & API
bearer token that was defined in the
Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

## EXAMPLES

### EXAMPLE 1
```powershell
Test-RocketCyberBaseURI -id 12345
```

Tests the base URI & API bearer token that was defined in the
Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

The default full base uri test path is:
    https://api-us.rocketcyber.com/v2/account/id

### EXAMPLE 2
```powershell
Test-RocketCyberBaseURI -base_uri http://myapi.gateway.example.com -id 12345
```

Tests the base URI & API bearer token that was defined in the
Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

The full base uri test path in this example is:
    http://myapi.gateway.example.com/id

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Test-RocketCyberAPIKey.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Test-RocketCyberAPIKey.html)

