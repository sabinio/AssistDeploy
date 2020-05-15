---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Set-EnvironmentVariableProperty

## SYNOPSIS
Set the given property to a given value

## SYNTAX

```
Set-EnvironmentVariableProperty [[-sqlConn] <SqlConnection>] [[-ssisVar] <PSObject>] [[-ssisProp] <Hashtable>]
 [[-PropertyName] <String>] [[-PropertyValue] <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates a given property to a given value - if data type has been altered then we parameterName will be "Type". 
If description altered then "description".
These are the only two properties that can be altered.

## EXAMPLES

### EXAMPLE 1
```
Set-EnvironmentVariableProperty -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties -PropertyName "Description" -PropertyValue $ssisVariable.Description
Set-EnvironmentVariableProperty -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties -PropertyName "Type" -PropertyValue $ssisVariable.dataType
```

## PARAMETERS

### -sqlConn
{{ Fill sqlConn Description }}

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
Settings of target variable

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
Properties of deployment (folder/project/environment)

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

### -PropertyName
Either description or type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyValue
{{ Fill PropertyValue Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
