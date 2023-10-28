---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Get-RCApps.html
parent: Special
schema: 2.0.0
title: Get-RCApps
---

# Get-RCApps

## SYNOPSIS
Gets an accounts apps from the RocketCyber API.

## SYNTAX

## DESCRIPTION
The Get-RocketCyberApps cmdlet gets an accounts apps
from the RocketCyber API.

Can be used with the Get-RocketCyberEvents cmdlet

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberApps
```

Gets active apps from accounts accessible
by the bearer token

### EXAMPLE 2
```powershell
Get-RocketCyberApps -accountId 12345
```

Gets active apps from account 12345.

### EXAMPLE 3
```powershell
Get-RocketCyberApps -accountId 12345 -status inactive
```

Gets inactive apps from account 12345.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Apps/Get-RocketCyberApps.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Apps/Get-RocketCyberApps.html)

