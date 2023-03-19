---
external help file: RocketCyberAPI-help.xml
grand_parent: Internal
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberBaseURI.html
parent: POST
schema: 2.0.0
title: Add-RocketCyberBaseURI
---

# Add-RocketCyberBaseURI

## SYNOPSIS
Sets the base URI for the RocketCyber API connection.

## SYNTAX

```powershell
Add-RocketCyberBaseURI [[-base_uri] <String>] [[-data_center] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-RocketCyberBaseURI cmdlet sets the base URI which is later used
to construct the full URI for all API calls.

## EXAMPLES

### EXAMPLE 1
```powershell
Add-RocketCyberBaseURI
```

The base URI will use https://api-us.rocketcyber.com/v3 which is RocketCyber's default URI.

### EXAMPLE 2
```powershell
Add-RocketCyberBaseURI -data_center EU
```

The base URI will use https://api-eu.rocketcyber.com/v3 which is RocketCyber's Europe URI.

### EXAMPLE 3
```powershell
Add-RocketCyberBaseURI -base_uri http://myapi.gateway.example.com
```

A custom API gateway of http://myapi.gateway.example.com will be used for
all API calls to RocketCyber's API.

## PARAMETERS

### -base_uri
Define the base URI for the RocketCyber API connection using
RocketCyber's URI or a custom URI.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://api-us.rocketcyber.com/v3
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -data_center
RocketCyber's URI connection point that can be one of the predefined data centers.

The accepted values for this parameter are:
\[ US, EU \]
US = https://api-us.rocketcyber.com/v3
EU = https://api-eu.rocketcyber.com/v3

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberBaseURI.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberBaseURI.html)

