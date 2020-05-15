---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Set-IscProperty

## SYNOPSIS
Overwrite the value that is imported

## SYNTAX

```
Set-IscProperty [-iscProperties] <Hashtable> [-newSsisFolderName <String>] [-newSsisProjectName <String>]
 [-newSsisEnvironmentName <String>] [-newSsisEnvironmentDescription <String>] [<CommonParameters>]
```

## DESCRIPTION
Internal function
All properties are inherited from the publish json file,
but there may come a time when we need to overwrite it (when testing)
or through Octopus step templates (using UI in fields)
This is called internally by other functions when
parameter is added to callingsomething like "publish-ssisFolder"

## EXAMPLES

### EXAMPLE 1
```
if ($ssisFolderName) {
$ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisFolderName $ssisFolderName
}
```

## PARAMETERS

### -iscProperties
The hash table that we are altering a property of.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -newSsisFolderName
Optional parameter.
Updated value of parameter.

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

### -newSsisProjectName
Optional parameter.
Updated value of parameter.

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

### -newSsisEnvironmentName
Optional parameter.
Updated value of parameter.

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

### -newSsisEnvironmentDescription
Optional parameter.
Updated value of parameter.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
