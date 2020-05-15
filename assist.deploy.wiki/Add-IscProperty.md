---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Add-IscProperty

## SYNOPSIS
Add a property to the hash table

## SYNTAX

```
Add-IscProperty [-iscProperties] <Hashtable> [-ssisPropertyName] <String> [-ssisPropertyValue] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Internal function
Add a value to the hash table for use further in the functions

## EXAMPLES

### EXAMPLE 1
```
$ssisProperties = Add-IscProperty -iscProperties $ssisProperties -ssisPropertyName "ssisNewEnvironmentName" -ssisPropertyValue $ssisNewEnvironmentName
```

## PARAMETERS

### -iscProperties
The hash table that we are adding a property to.

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

### -ssisPropertyName
The name of the property - we may wish to add a new envrionment name to the list of properties we are passing around.

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

### -ssisPropertyValue
The value of the given property ie the name of the new environment name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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
For working example, see "EditSSISEnvironmentName.ps1"
Generally used in a rollback scenario, but seeing as we are not supporting this scenario currently it is not in use in any of the tests.

## RELATED LINKS
