---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Get-RCOffice.html
parent: Special
schema: 2.0.0
title: Get-RCOffice
---

# Get-RCOffice

## SYNOPSIS
Gets office information from the RocketCyber API

## SYNTAX

## DESCRIPTION
The Get-RocketCyberOffice cmdlet gets office information
from all or a defined accountId.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberOffice
```

Office data will be retrieved from all accounts accessible
by the bearer token

### EXAMPLE 2
```powershell
Get-RocketCyberOffice -accountId 12345
```

Office data will be retrieved from the accountId 12345

### EXAMPLE 3
```powershell
12345 | Get-RocketCyberOffice
```

Office data will be retrieved from the accountId 12345

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Office/Get-RocketCyberOffice.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Office/Get-RocketCyberOffice.html)

