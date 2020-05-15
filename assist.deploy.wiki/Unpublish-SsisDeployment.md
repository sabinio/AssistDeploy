---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Unpublish-SsisDeployment

## SYNOPSIS
Rollback ispac deployment: reverts to previous version of deployed project.

## SYNTAX

```
Unpublish-SsisDeployment [-jsonPsCustomObject] <PSObject> [-sqlConnection] <SqlConnection>
 [[-ssisFolderName] <String>] [[-ssisProjectName] <String>] [[-ssisProjectLsn] <String>] [-delete]
 [<CommonParameters>]
```

## DESCRIPTION
If a validate project has failed and we wish to rollback we needto revert to previous working project
First it checks that you can rollback (ie previous versions are stored)

## EXAMPLES

### EXAMPLE 1
```
$ssisLatestProjectLsn = Get-SsisProjectLsn -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
do deployment....
do validation...
validation fails...
if ($null -eq $ssisLatestProjectLsn) {
Unpublish-SsisDeployment -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -ssisProjectLsn $ssisLatestProjectLsn
}
else {
Unpublish-SsisDeployment -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -delete
}
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

### -ssisProjectName
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

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -delete
Optional parameter.
Will delete a project.
Can be used when there is no project version to roll back to.
Or can be used as a nucelar option.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
