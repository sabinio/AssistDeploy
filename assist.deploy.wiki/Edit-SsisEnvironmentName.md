---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Edit-SsisEnvironmentName

## SYNOPSIS
This executes the stored procedure "rename environment", effectively appending the current SSIS Project LSN to the name.

## SYNTAX

```
Edit-SsisEnvironmentName [-jsonPsCustomObject] <PSObject> [-sqlConnection] <SqlConnection>
 [[-ssisFolderName] <String>] [[-ssisEnvironmentName] <String>] [-ssisProjectLsn] <String> [<CommonParameters>]
```

## DESCRIPTION
Before we re-write the values stored in an environment, we can effectively take a back up of the current environment by re-naming it.
We can used the return name to revert this back to the original name if we need to rollback if a validation has failed

## EXAMPLES

### EXAMPLE 1
```
$ssisEnvironmentRename = Edit-SsisEnvironmentName -ssisPublishFilePath $thisSsisPublishFilePath -ssisProjectLsn $thisLsn -sqlConnection $ssisdb
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

### -ssisProjectLsn
Retrieved from ISC by using Get-SsisProjectLsn function.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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
