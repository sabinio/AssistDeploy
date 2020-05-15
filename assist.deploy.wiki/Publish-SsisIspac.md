---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Publish-SsisIspac

## SYNOPSIS
Publish an ispac to a project folder.

## SYNTAX

```
Publish-SsisIspac [-jsonPsCustomObject] <PSObject> [-sqlConnection] <SqlConnection> [-ispacToDeploy] <String>
 [[-ssisFolderName] <String>] [[-ssisProjectName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Publish an ispac and check that it was deployed.
$ispacToDeploy is a file path.
We convert into bits and pass in.
Non-mandatory params here can be used to overwrite the values stored in the publish json file passed in

## EXAMPLES

### EXAMPLE 1
```
1)
Publish-SsisIspac -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -ispacToDeploy $thisIspacToDeploy
2)
Publish-SsisIspac -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -ispacToDeploy $thisIspacToDeploy -ssisFolderName "newFolder"
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

### -ispacToDeploy
File path to ispac we want to deploy.
Convert to byte object then execute as VARBINARY

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

### -ssisFolderName
Optional parameter.
We may wish to override the value of what is in the json file.

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

### -ssisProjectName
Optional parameter.
We may wish to override the value of what is in the json file.

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
