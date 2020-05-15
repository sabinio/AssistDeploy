---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# New-ssisVariable

## SYNOPSIS
Drops Environment variable if it exists and creates an environment variable

## SYNTAX

```
New-ssisVariable [[-sqlConn] <SqlConnection>] [[-ssisVar] <PSObject>] [[-ssisProp] <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION
Internal function
Checks if a variable exists, and if it does then it drops and creates a new one.
Used where we need to create a new variable, or where data type and value have changed at same time (easier to drop and re-create when this has occured).

## EXAMPLES

### EXAMPLE 1
```
See PublishSsisVariables for full context
New-SsisVariable -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties
```

## PARAMETERS

### -sqlConn
connection to SSIS Server

```yaml
Type: SqlConnection
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ssisVar
The target variable we want to create/re-create

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ssisProp
The properties (ie folder/project/environment name)

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
