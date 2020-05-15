---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Test-ProjectParamsMatch

## SYNOPSIS
Import the integration services catalog publish json file

## SYNTAX

```
Test-ProjectParamsMatch [-jsonObject] <PSObject> [-ispacPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Internal function used to import the json file that stores the integration services catalog properties and variables.

## EXAMPLES

### EXAMPLE 1
```
Test-ProjectParamsMatch -jsonObject "C:\Users\SQLTraining\Documents\iscPublish.json" -ispacPath "C:\Users\SQLTraining\Documents\iscPublish.ispac"
```

## PARAMETERS

### -jsonObject
Json object.

```yaml
Type: PSObject
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
