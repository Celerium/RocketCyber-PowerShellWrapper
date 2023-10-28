---
external help file: RocketCyberAPI-help.xml
grand_parent: Firewalls
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Firewalls/Get-RocketCyberFirewalls.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberFirewalls
---

# Get-RocketCyberFirewalls

## SYNOPSIS
Gets RocketCyber firewalls from an account.

## SYNTAX

```powershell
Get-RocketCyberFirewalls [[-accountId] <Int64[]>] [[-deviceId] <String>] [[-ipAddress] <String>]
 [[-macAddress] <String[]>] [[-type] <String[]>] [-counters] [[-page] <Int32>] [[-pageSize] <Int32>]
 [[-sort] <String>] [-allPages] [<CommonParameters>]
```

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

### -accountId
The account id associated to the device

If not provided, data will be pulled for all accounts
accessible by the bearer token.

Multiple comma separated values can be inputted

```yaml
Type: Int64[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -deviceId
The device ID tied to the device.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ipAddress
The IP address tied to the device.

As of 2023-03 this endpoint does not return
IP address information

Example:
    172.25.5.254

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -macAddress
The MAC address tied to the device.

Example:
    ae:b1:69:29:55:24

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -type
The type of device.

Example:
    SonicWall,Fortinet

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -counters
Flag to include additional firewall counter data

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -page
The target page of data.

This is used with pageSize parameter to determine how many
and which items to return.

\[Default\] 1

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -pageSize
The number of items to return from the data set.

\[Default\] 1000
\[Maximum\] 1000

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -sort
The sort order for the items queried.

Not all values can be sorted

Example:
    accountId:asc
    accountId:desc

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -allPages
Returns all items from an endpoint

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Firewalls/Get-RocketCyberFirewalls.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Firewalls/Get-RocketCyberFirewalls.html)

