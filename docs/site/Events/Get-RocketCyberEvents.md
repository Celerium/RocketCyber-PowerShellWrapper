---
external help file: RocketCyberAPI-help.xml
grand_parent: Events
Module Name: RocketCyberAPI
online version: https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Events/Get-RocketCyberEvents.html
parent: GET
schema: 2.0.0
title: Get-RocketCyberEvents
---

# Get-RocketCyberEvents

## SYNOPSIS
Gets app event information from the RocketCyber API.

## SYNTAX

### indexByEvent (Default)
```powershell
Get-RocketCyberEvents -appId <Int32> [-verdict <String[]>] [-accountId <Int64[]>] [-details <String>]
 [-dates <String>] [-page <Int32>] [-pageSize <Int32>] [-sort <String>] [-allPages] [<CommonParameters>]
```

### indexByEventSummary
```powershell
Get-RocketCyberEvents [-accountId <Int64[]>] [-eventSummary] [<CommonParameters>]
```

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

### -appId
The app ID.

```yaml
Type: Int32
Parameter Sets: indexByEvent
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -verdict
The verdict of the event.

Multiple comma separated values can be inputted

Allowed Values:
'informational', 'suspicious', 'malicious'

```yaml
Type: String[]
Parameter Sets: indexByEvent
Aliases:

Required: False
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -eventSummary
Shows summary of events for each app

```yaml
Type: SwitchParameter
Parameter Sets: indexByEventSummary
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -details
This parameter allows users to target specific attributes within the details object.

This requires you to define the attribute path (period separated) and the expected value.

The value can include wildcards (*)

Example: (appId 7)
    attributes.direction:outbound

```yaml
Type: String
Parameter Sets: indexByEvent
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dates
The date range for event detections.

Both the start and end dates are optional, but at least one is
required to use this parameter.

Cannot be used with the startDate & endDate parameters

Start Time  |  End Time

Example:
    2022-05-09  |2022-05-10
    2022-05-09  |
                |2022-05-10

```yaml
Type: String
Parameter Sets: indexByEvent
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
Parameter Sets: indexByEvent
Aliases:

Required: False
Position: Named
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
Parameter Sets: indexByEvent
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -sort
The sort order for the items queried.

Not all values can be sorted

Example:
    verdict:asc
    dates:desc

```yaml
Type: String
Parameter Sets: indexByEvent
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
Parameter Sets: indexByEvent
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
As of 2023-03
    Other than the parameters shown here, app specific parameters vary from app to app,
    however I have not found any documentation around this.

## RELATED LINKS

[https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Events/Get-RocketCyberEvents.html](https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Events/Get-RocketCyberEvents.html)

