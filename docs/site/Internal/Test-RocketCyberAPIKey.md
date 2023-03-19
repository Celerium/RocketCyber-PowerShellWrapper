---
external help file: RocketCyberAPI-help.xml
grand_parent: Internal
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Test-RocketCyberAPIKey.html
parent: GET
schema: 2.0.0
title: Test-RocketCyberAPIKey
---

# Test-RocketCyberAPIKey

## SYNOPSIS
Test the RocketCyber API bearer token.

## SYNTAX

```powershell
Test-RocketCyberAPIKey [[-base_uri] <String>] [<CommonParameters>]
```

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

### -base_uri
Define the base URI for the RocketCyber API connection using RocketCyber's URI or a custom URI.

The default base URI is https://api-us.rocketcyber.com/v3

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $RocketCyber_Base_URI
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Test-RocketCyberAPIKey.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Test-RocketCyberAPIKey.html)

