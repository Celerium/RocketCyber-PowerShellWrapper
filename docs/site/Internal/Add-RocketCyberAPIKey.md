---
external help file: RocketCyberAPI-help.xml
grand_parent: Internal
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberAPIKey.html
parent: POST
schema: 2.0.0
title: Add-RocketCyberAPIKey
---

# Add-RocketCyberAPIKey

## SYNOPSIS
Sets your API bearer token used to authenticate all API calls.

## SYNTAX

```powershell
Add-RocketCyberAPIKey [[-Api_Key] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-RocketCyberAPIKey cmdlet sets your API bearer token which is used to
authenticate all API calls made to RocketCyber.
Once the API bearer token is
defined, it is encrypted using SecureString.

The RocketCyber API bearer tokens are generated via the RocketCyber web interface
at Provider Settings \> RocketCyber API

## EXAMPLES

### EXAMPLE 1
```powershell
Add-RocketCyberAPIKey
```

Prompts to enter in the API bearer token

### EXAMPLE 2
```powershell
Add-RocketCyberAPIKey -Api_key 'your_api_key'
```

The RocketCyber API will use the string entered into the \[ -Api_Key \] parameter.

### EXAMPLE 3
```
'12345' | Add-RocketCyberAPIKey
```

The Add-RocketCyberAPIKey function will use the string passed into it as its API bearer token.

## PARAMETERS

### -Api_Key
Define your API bearer token that was generated from RocketCyber.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ApiKey

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberAPIKey.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberAPIKey.html)

