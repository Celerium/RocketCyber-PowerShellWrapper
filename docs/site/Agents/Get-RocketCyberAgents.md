---
external help file: RocketCyberAPI-help.xml
grand_parent: Agents
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Agents/Get-RocketCyberAgents.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberAgents
---

# Get-RocketCyberAgents

## SYNOPSIS
Gets RocketCyber agents from an account.

## SYNTAX

### index (Default)
```powershell
Get-RocketCyberAgents [-accountId <Int64[]>] [-id <String[]>] [-hostname <String[]>] [-ip <String[]>]
 [-created <String>] [-os <String>] [-version <String>] [-connectivity <String[]>] [-page <Int32>]
 [-pageSize <Int32>] [-sort <String>] [-allPages] [<CommonParameters>]
```

### indexByCustomTime
```powershell
Get-RocketCyberAgents [-accountId <Int64[]>] [-id <String[]>] [-hostname <String[]>] [-ip <String[]>]
 [-startDate <DateTime>] [-endDate <DateTime>] [-os <String>] [-version <String>] [-connectivity <String[]>]
 [-page <Int32>] [-pageSize <Int32>] [-sort <String>] [-allPages] [<CommonParameters>]
```

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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The agent id

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hostname
The device hostname

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ip
The IP address tied to the device

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -created
The date range for when agents were created

Both the start and end dates are optional, but at least one is
required to use this parameter.

Cannot be used with the startDate & endDate parameters

Start UTC Time  |  End UTC Time

Example:
    2022-05-09T00:33:38.245Z|2022-05-10T23:59:38.245Z
    2022-05-09T00:33:38.245Z|
                            |2022-05-10T23:59:38.245Z

```yaml
Type: String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -startDate
The friendly start date for when agents were created

Both the start and end dates are optional, but at least one is
required to use this parameter.

Cannot be used with the created parameter

Date needs to be inputted as yyyy-mm-dd hh:mm:ss

Example:
    2022-05-09 12:30:10

```yaml
Type: DateTime
Parameter Sets: indexByCustomTime
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -endDate
The friendly end date for when agents were created

Both the start and end dates are optional, but at least one is
required to use this parameter.

Cannot be used with the created parameter

Date needs to be inputted as yyyy-mm-dd hh:mm:ss

Example:
    2022-05-09 12:30:10

```yaml
Type: DateTime
Parameter Sets: indexByCustomTime
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -os
The OS used by the device

As of 2023-03 using * do not appear to work correctly

Example:
    Windows*
    Windows

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -version
The agent version.

As of 2023-03 this filter appears not to work correctly

Example:
    Server 2019

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -connectivity
The connectivity status of the agent

Multiple comma separated values can be inputted

Allowed values:
    'online', 'offline', 'isolated'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
Position: Named
Default value: 1
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
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -sort
The sort order for the items queried.

Not all values can be sorted

Example:
    hostname:asc
    accountId:desc

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Agents/Get-RocketCyberAgents.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Agents/Get-RocketCyberAgents.html)

