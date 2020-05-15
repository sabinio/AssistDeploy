---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Unpublish-SsisEnvironmentReference

## SYNOPSIS
If exists, remove a reference between a project and environment and check it is removed.

## SYNTAX

```
Unpublish-SsisEnvironmentReference [-jsonPsCustomObject] <PSObject> [-sqlConnection] <SqlConnection>
 [[-ssisFolderName] <String>] [[-ssisEnvironmentName] <String>] [[-ssisProjectName] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
We may wish to remove a reference between an environment and a project.
This function will check if an environment reference exists, and if it does, it will delete it.
Non-mandatory params here can be used to overwrite the values stored in the publish json file passed in
It will verify that it is deleted.

## EXAMPLES

### EXAMPLE 1
```
Unpublish-SsisEnvironmentReference -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
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

### -ssisEnvironmentName
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
