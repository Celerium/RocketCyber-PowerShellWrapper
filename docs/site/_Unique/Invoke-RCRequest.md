---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/Invoke-RCRequest.html
parent: Special
schema: 2.0.0
title: Invoke-RCRequest
---

# Invoke-RCRequest

## SYNOPSIS
Makes an API request

## SYNTAX

## DESCRIPTION
The Invoke-RocketCyberRequest cmdlet invokes an API request to RocketCyber API.

This is an internal function that is used by all public functions

As of 2023-08 the RocketCyber v1 API only supports GET requests

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-RocketCyberRequest -method GET -resource_Uri '/account' -uri_Filter $uri_Filter
```

Invoke a rest method against the defined resource using any of the provided parameters

Example:
    Name                           Value
    ----                           -----
    Method                         GET
    Uri                            https://api-us.rocketcyber.com/v3/account?accountId=12345&details=True
    Headers                        {Authorization = Bearer 123456789}
    Body

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Invoke-RocketCyberRequest.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Invoke-RocketCyberRequest.html)

