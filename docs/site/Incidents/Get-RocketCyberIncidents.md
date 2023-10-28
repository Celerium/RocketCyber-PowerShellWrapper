---
external help file: RocketCyberAPI-help.xml
grand_parent: Incidents
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Incidents/Get-RocketCyberIncidents.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberIncidents
---

# Get-RocketCyberIncidents

## SYNOPSIS
Gets incident information from the RocketCyber API

## SYNTAX

```powershell
Get-RocketCyberIncidents [[-id] <Int32[]>] [[-title] <String[]>] [[-accountId] <Int64[]>]
 [[-description] <String[]>] [[-remediation] <String>] [[-resolvedAt] <String>] [[-createdAt] <String>]
 [[-status] <String[]>] [[-page] <Int32>] [[-pageSize] <Int32>] [[-sort] <String>] [-allPages]
 [<CommonParameters>]
```

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

### -id
The RocketCyber incident ID.

Multiple comma separated values can be inputted

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -title
The title of the incident.

Example:
    Office*

Multiple comma separated values can be inputted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -description
The description of the incident.

NOTE: Wildcards are required to search for specific text.

Example:
    administrative

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

### -remediation
The remediation for the incident.

NOTE: Wildcards are required to search for specific text.

Example:
    permission*

As of 2023-03 this parameters does not appear to work

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resolvedAt
This returns incidents resolved between the start and end date.

Both the start and end dates are optional, but at least one is
required to use this parameter.

Start Time  |  End Time

Example:
    2022-05-09  |2022-05-10
    2022-05-09  |
                |2022-05-10

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -createdAt
This returns incidents created between the start and end date.

Both the start and end dates are optional, but at least one is
required to use this parameter.

Start Time  |  End Time

Example:
    2022-05-09  |2022-05-10
    2022-05-09  |
                |2022-05-10

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -status
The type of incidents to request.

Allowed Values:
    'open', 'resolved'

As of 2023-03 the documentation defines the
allowed values listed below but not all work

'all', 'open', 'closed'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
Position: 9
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
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -sort
The sort order for the items queried.

Not all values can be sorted

Example:
    accountId:asc
    title:desc

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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
As of 2023-03:
    Any parameters that say wildcards are required is not valid

    Using wildcards in the query string do not work as the endpoint
    already search's via wildcard.
If you use a wildcard '*' it
    will not return any results.

The remediation parameter does not appear to work

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Incidents/Get-RocketCyberIncidents.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Incidents/Get-RocketCyberIncidents.html)

