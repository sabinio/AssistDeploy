---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Invoke-ValidateSsisProject

## SYNOPSIS
After a deployment of the folder/environment/variables/ispac/environment reference, run a validate project.

## SYNTAX

```
Invoke-ValidateSsisProject [-jsonPsCustomObject] <PSObject> [-sqlConnection] <SqlConnection>
 [[-ssisFolderName] <String>] [[-ssisProjectName] <String>] [[-ssisEnvironmentName] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
We may wish to validate that the dtsx packages in a project will run successfully
This function will run a validation and return a validation status.
Any validation status other than 7 means something has gone wrong.
The function checks the status itself and will return an error if status is not 7.
We can use the output from this function to run other functions to rollback deployment (ie if $status -ne "suceeded")
{
Unpublish-SsisDeployment
undo-ssisEnvironmentReference
Unpublish-SsisEnvironment
Edit-SsisEnvironmentName
}
This assumes you have run "unpublish-environmentReference" and "edit-ssisEnvironmentName" prior to deployment
I am not a huge fan of roling back, but the functionality exists in this module if people want to use it.

## EXAMPLES

### EXAMPLE 1
```
$validationStatus = Invoke-ValidateSsisProject -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
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

### -ssisEnvironmentName
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
