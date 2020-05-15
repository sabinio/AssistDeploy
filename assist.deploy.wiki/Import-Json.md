---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Import-Json

## SYNOPSIS
Import the integration services catalog publish json file

## SYNTAX

```
Import-Json [-jsonPath] <String> [-ispacPath] <String> [-localVariables] [[-variableType] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Internal function used to import the json file that stores the integration services catalog properties and variables.

## EXAMPLES

### EXAMPLE 1
```
$ssisJson = Import-Json -jsonPath "C:\Users\SQLTraining\Documents\iscPublish.json" -ispacPath "C:\Users\SQLTraining\Documents\iscPublish.ispac"
```

## PARAMETERS

### -jsonPath
File path of json file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ispacPath
File path of ispac file.

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

### -localVariables
Switch to determine whether we need to validate that variables with the name of the variableName exists or not in current session.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -variableType
Existence checks for variables can be either for Powershell variables (e.g.
$Foo) or Environment variables (e.g.
$Env:Foo). 
Deployment tools store values in different ways.
This give some control as to where the variables should be checked.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: PS
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
