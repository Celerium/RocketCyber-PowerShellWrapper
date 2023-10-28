---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Get-RCIncidents.html
parent: Special
schema: 2.0.0
title: Get-RCIncidents
---

# Get-RCIncidents

## SYNOPSIS
Gets incident information from the RocketCyber API

## SYNTAX

## DESCRIPTION
The Get-RocketCyberIncidents cmdlet gets incident information
associated to all or a defined account ID.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-RocketCyberIncidents
```

Gets the first 1000 incidents from all accounts accessible
by the bearer token

### EXAMPLE 2
```powershell
Get-RocketCyberIncidents -accountId 12345 -Id 9876
```

Gets the defined incident Id from the defined accountId

### EXAMPLE 3
```powershell
Get-RocketCyberIncidents -title nmap -resolvedAt '2023-01-01|'
```

Gets the first 1000 incidents from all accounts accessible
by the bearer token that were resolved after the defined
startDate with the defined word in the title.

### EXAMPLE 4
```powershell
Get-RocketCyberIncidents -description audit -createdAt '|2023-03-01'
```

Gets the first 1000 incidents from all accounts accessible
by the bearer token that were created before the defined
endDate with the defined word in the description.

### EXAMPLE 5
```powershell
Get-RocketCyberIncidents -status resolved -sort title:asc
```

Gets the first 1000 resolved incidents from all accounts accessible
by the bearer token and the data is return by title in
ascending order.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
As of 2023-03:
    Any parameters that say wildcards are required is not valid

    Using wildcards in the query string do not work as the endpoint
    already search's via wildcard.
If you use a wildcard '*' it
    will not return any results.

The remediation parameter does not appear to work

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Incidents/Get-RocketCyberIncidents.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Incidents/Get-RocketCyberIncidents.html)

