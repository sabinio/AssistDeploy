---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Publish-SsisVariables

## SYNOPSIS
Publish and associate variables in publish json file to corresponding environment and project.

## SYNTAX

```
Publish-SsisVariables [-jsonPsCustomObject] <PSObject> [-sqlConnection] <SqlConnection>
 [[-ssisFolderName] <String>] [[-ssisEnvironmentName] <String>] [[-ssisProjectName] <String>] [-localVariables]
 [-whatIf] [[-variableType] <String>] [<CommonParameters>]
```

## DESCRIPTION
For each environment variable in json file, function checks if variable already exists.
If it does not exist then it creates it.
If it does exist then it checks if any of hte following have altered:
        value
        dataType
        Sensitivity
        description
If any of these have changed it alters those values only.
If both data type and value have changed, then current var is dropped and re-created, as blocking changes. 
Functionality to create/alter are in separate functions:
    new-ssisvariable
    set-environmentvariableproperty
    set-environmentvariableprotection
    set-environmentvariablevalue

## EXAMPLES

### EXAMPLE 1
```
Publish-SsisVariables -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -localVariables
Non-mandatory params here can be used to overwrite the values stored in the publish json file passed in
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

### -localVariables
Optional parameter.
If used then values stored in json file are used.
If not used then PowerShell variables need to exist either 
as full PS variables (e.g.
$Foo) or Environment variables (e.g.
$Env:Foo) that have the same name as variables in json file.

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

### -whatIf
Optional parameter.
If used then no changes are made on server.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -variableType
Variables can be either full Powershell variables (e.g.
$Foo) or Environment variables (e.g.
$Env:Foo).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
