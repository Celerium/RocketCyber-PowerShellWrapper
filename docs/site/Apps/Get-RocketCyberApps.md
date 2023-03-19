---
external help file: RocketCyberAPI-help.xml
grand_parent: Apps
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Apps/Get-RocketCyberApps.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberApps
---

# Get-RocketCyberApps

## SYNOPSIS
Gets an accounts apps from the RocketCyber API.

## SYNTAX

```powershell
Get-RocketCyberApps [-accountId <Int64>] [-status <String>] [<CommonParameters>]
```

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

### -status
The type of apps to request

Acceptable values are:
    'active', 'inactive'

The default value is 'active'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Apps/Get-RocketCyberApps.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Apps/Get-RocketCyberApps.html)

