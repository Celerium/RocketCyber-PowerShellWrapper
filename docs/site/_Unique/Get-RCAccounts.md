---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Get-RCAccounts.html
parent: Special
schema: 2.0.0
title: Get-RCAccounts
---

# Get-RCAccounts

## SYNOPSIS
Gets account information for a given ID.

## SYNTAX

## DESCRIPTION
The Get-RocketCyberAccount cmdlet gets account information all
accounts or for a given ID from the RocketCyber API.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberAccount
```

Account data will be retrieved from all accounts accessible
by the bearer token

### EXAMPLE 2
```powershell
Get-RocketCyberAccount -accountId 12345
```

Account data will be retrieved for the account with the accountId 12345.

### EXAMPLE 3
```powershell
12345 | Get-RocketCyberAccount
```

Account data will be retrieved for the account with the accountId 12345.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Accounts/Get-RocketCyberAccounts.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Accounts/Get-RocketCyberAccounts.html)

