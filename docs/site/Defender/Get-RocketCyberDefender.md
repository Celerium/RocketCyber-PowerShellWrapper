---
external help file: RocketCyberAPI-help.xml
grand_parent: Defender
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Defender/Get-RocketCyberDefender.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberDefender
---

# Get-RocketCyberDefender

## SYNOPSIS
Gets defender information from the RocketCyber API.

## SYNTAX

```powershell
Get-RocketCyberDefender [-accountId <Int64>] [<CommonParameters>]
```

## DESCRIPTION
The Get-RocketCyberDefender cmdlet gets an accounts defender information
from the RocketCyber API.

This includes various health & risk values

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberDefender
```

Gets defender information all accounts accessible
by the bearer token

### EXAMPLE 2
```powershell
Get-RocketCyberDefender -accountId 12345
```

Gets defender information from account 12345

## PARAMETERS

### -accountId
The account ID to pull data for.

If not provided, data will be pulled for all accounts
accessible by the bearer token.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Defender/Get-RocketCyberDefender.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Defender/Get-RocketCyberDefender.html)

