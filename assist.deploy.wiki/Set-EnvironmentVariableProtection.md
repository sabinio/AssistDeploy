---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Set-EnvironmentVariableProtection

## SYNOPSIS
Alters protection level of variable

## SYNTAX

```
Set-EnvironmentVariableProtection [[-sqlConn] <SqlConnection>] [[-ssisVar] <PSObject>]
 [[-ssisProp] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
Alters protection level of variable...
IDK what else to say

## EXAMPLES

### EXAMPLE 1
```
Set-EnvironmentVariableProtection -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties
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
new value.

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
