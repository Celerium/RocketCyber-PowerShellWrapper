---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Add-RCBaseURI.html
parent: Special
schema: 2.0.0
title: Add-RCBaseURI
---

# Add-RCBaseURI

## SYNOPSIS
Sets the base URI for the RocketCyber API connection.

## SYNTAX

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberBaseURI.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberBaseURI.html)

