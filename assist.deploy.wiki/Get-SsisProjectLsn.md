---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Get-SsisProjectLsn

## SYNOPSIS
Get latest project lsn.
This is effectively the version number of the project.

## SYNTAX

```
Get-SsisProjectLsn [-jsonPsCustomObject] <PSObject> [-sqlConnection] <SqlConnection>
 [[-ssisFolderName] <String>] [<CommonParameters>]
```

## DESCRIPTION
useful for when we may need to rollback, this is the latest lsn for a given project.

## EXAMPLES

### EXAMPLE 1
```
$ssisLatestProjectLsn = Get-SsisProjectLsn -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
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
Used in rollback process, but seeing as we're not currently using that process this is not currently in use.

## RELATED LINKS
