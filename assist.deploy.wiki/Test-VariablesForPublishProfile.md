---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Test-VariablesForPublishProfile

## SYNOPSIS
Validates variables used in the publish profile

## SYNTAX

```
Test-VariablesForPublishProfile [-jsonPsCustomObject] <PSObject> [-localVariables] [[-variableType] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Validates variables used in the publish profile. 
If -localVariables is false, this function tries to find a variable - either a true powershell variable (e.g.
$Foo),
or an environment variable (e.g.
$Env:Foo) for each property found in $jsonPsCustomObject.ssisEnvironmentVariable.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -jsonPsCustomObject
{{ Fill jsonPsCustomObject Description }}

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

### -localVariables
{{ Fill localVariables Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -variableType
{{ Fill variableType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
