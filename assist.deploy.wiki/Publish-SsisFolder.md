---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Publish-SsisFolder

## SYNOPSIS
Create a catalog folder

## SYNTAX

```
Publish-SsisFolder [-jsonPsCustomObject] <PSObject> [-sqlConnection] <SqlConnection>
 [[-ssisFolderName] <String>] [<CommonParameters>]
```

## DESCRIPTION
If not exists, create a catalog folder
We will then be ableto deploy projects and environments
Non-mandatory params here can be used to overwrite the values stored in the publish json file passed in

## EXAMPLES

### EXAMPLE 1
```
Publish-SsisFolder -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
Publish-SsisFolder -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -ssisFolderName "bob"
```

## PARAMETERS

### -jsonPsCustomObject
Tested json object loaded from Import-Json

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

### -sqlConnection
The SQL Connection to SSISDB

```yaml
Type: SqlConnection
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ssisFolderName
Optional parameter.
We may wish to override the value of what is in the json file.

```yaml
Type: String
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
