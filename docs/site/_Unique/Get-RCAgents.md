---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Get-RCAgents.html
parent: Special
schema: 2.0.0
title: Get-RCAgents
---

# Get-RCAgents

## SYNOPSIS
Gets RocketCyber agents from an account.

## SYNTAX

## DESCRIPTION
The Get-RocketCyberAgents cmdlet gets agent information
for all accounts or for agents associated to an account ID.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberAgents
```

Gets the first 1000 agents from all accounts accessible
by the bearer token

### EXAMPLE 2
```powershell
Get-RocketCyberAgents -id 12345
```

Gets the first 1000 agents from account 12345.

### EXAMPLE 3
```powershell
Get-RocketCyberAgents -id 12345 -sort hostname:asc
```

Gets the first 1000 agents from account 12345.

Data is sorted by hostname and returned in ascending order.

### EXAMPLE 4
```powershell
Get-RocketCyberAgents -id 12345 -connectivity offline,isolated
```

Gets the first 1000 offline agents from account 12345 that are
either offline or isolated.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Agents/Get-RocketCyberAgents.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Agents/Get-RocketCyberAgents.html)

