---
external help file: RocketCyberAPI-help.xml
grand_parent: Internal
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/ConvertTo-RocketCyberQueryString.html
parent: PUT
schema: 2.0.0
title: ConvertTo-RocketCyberQueryString
---

# ConvertTo-RocketCyberQueryString

## SYNOPSIS
Converts uri filter parameters

## SYNTAX

```powershell
ConvertTo-RocketCyberQueryString [-uri_Filter] <Hashtable> [-resource_Uri] <String> [<CommonParameters>]
```

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

### -uri_Filter
Hashtable of values to combine a functions parameters with
the resource_Uri parameter.

This allows for the full uri query to occur

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -resource_Uri
Defines the short resource uri (url) to use when creating the API call

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/ConvertTo-RocketCyberQueryString.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/ConvertTo-RocketCyberQueryString.html)

