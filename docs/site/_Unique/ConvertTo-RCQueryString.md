---
external help file: RocketCyberAPI-help.xml
grand_parent: _Unique
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/_Unique/ConvertTo-RCQueryString.html
parent: Special
schema: 2.0.0
title: ConvertTo-RCQueryString
---

# ConvertTo-RCQueryString

## SYNOPSIS
Converts uri filter parameters

## SYNTAX

## DESCRIPTION
The Invoke-RocketCyberRequest cmdlet converts & formats uri filter parameters
from a function which are later used to make the full resource uri for
an API call

This is an internal helper function the ties in directly with the
Invoke-RocketCyberRequest & any public functions that define parameters

## EXAMPLES

### EXAMPLE 1
```powershell
ConvertTo-RocketCyberQueryString -uri_Filter $uri_Filter -resource_Uri '/account'
```

Example: (From public function)
    $uri_Filter = @{}

    ForEach ( $Key in $PSBoundParameters.GetEnumerator() ){
        if( $excludedParameters -contains $Key.Key ){$null}
        else{ $uri_Filter += @{ $Key.Key = $Key.Value } }
    }

    1x key = https://api-us.rocketcyber.com/v3/account?accountId=12345
    2x key = https://api-us.rocketcyber.com/v3/account?accountId=12345&details=True

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/ConvertTo-RocketCyberQueryString.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/ConvertTo-RocketCyberQueryString.html)

