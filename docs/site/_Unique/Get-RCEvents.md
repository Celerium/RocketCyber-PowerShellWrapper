---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Get-RCEvents.html
parent: Special
schema: 2.0.0
title: Get-RCEvents
---

# Get-RCEvents

## SYNOPSIS
Gets app event information from the RocketCyber API.

## SYNTAX

## DESCRIPTION
The Get-RocketCyberEvents cmdlet gets app event information for
events associated to all or a defined account ID.

Use the Get-RockerCyberApp cmdlet to get app ids

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberEvents -appId 7
```

Gets the first 1000 appId 7 events from all accounts accessible
by the bearer token

### EXAMPLE 2
```powershell
Get-RocketCyberEvents -accountId 12345 -appId 7
```

Gets the first 1000 appId 7 events from account 12345

### EXAMPLE 3
```powershell
Get-RocketCyberEvents -appId 7 -sort dates:desc
```

Gets the first 1000 appId 7 events and the data set is sort
by dates in descending order.

### EXAMPLE 4
```powershell
Get-RocketCyberEvents -appId 7 -verdict suspicious
```

Gets the first 1000 appId 7 events and the data set is sort
by dates in descending order.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
As of 2023-03
    Other than the parameters shown here, app specific parameters vary from app to app,
    however I have not found any documentation around this.

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Events/Get-RocketCyberEvents.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Events/Get-RocketCyberEvents.html)

