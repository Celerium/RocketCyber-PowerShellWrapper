---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Get-RCFirewalls.html
parent: Special
schema: 2.0.0
title: Get-RCFirewalls
---

# Get-RCFirewalls

## SYNOPSIS
Gets RocketCyber firewalls from an account.

## SYNTAX

## DESCRIPTION
The Get-RocketCyberFirewalls cmdlet gets firewalls from
an account.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberFirewalls
```

Gets the first 1000 agents from all accounts accessible
by the bearer token

### EXAMPLE 2
```powershell
Get-RocketCyberFirewalls -accountId 12345
```

The first 1000 firewalls are pulled from accountId 12345

### EXAMPLE 3
```powershell
Get-RocketCyberFirewalls -macAddress '11:22:33:aa:bb:cc'
```

Get the firewall with the defined macAddress

### EXAMPLE 4
```powershell
Get-RocketCyberFirewalls -type SonicWall,Fortinet
```

Get firewalls with the defined type

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Firewalls/Get-RocketCyberFirewalls.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Firewalls/Get-RocketCyberFirewalls.html)

