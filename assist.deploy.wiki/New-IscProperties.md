---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# New-IscProperties

## SYNOPSIS
Takes Integration Services Catalog Properties and loads them into a hash table

## SYNTAX

```
New-IscProperties [-jsonObject] <PSObject> [<CommonParameters>]
```

## DESCRIPTION
Internal function
Used to return a hash table of the properties instead of using json objects
As it's a customObject anything could be loaded really.

## EXAMPLES

### EXAMPLE 1
```
$ssisProperties = New-IscProperties -jsonObject $ssisJson
```

## PARAMETERS

### -jsonObject
After we have called Import-Json we load values into a hash table for the "IntegrationServicesCatalog" properties
Used pretty much everywhere!

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
