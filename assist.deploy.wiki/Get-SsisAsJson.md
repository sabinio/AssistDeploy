---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Get-SsisAsJson

## SYNOPSIS
Convert Ssis project and parameters as json object.

## SYNTAX

```
Get-SsisAsJson [-sqlConnection] <SqlConnection> [-ssisFolder] <String> [-ssisEnvironment] <String>
 [-ssisProject] <String> [-ssisEnvironmentDescription] <String> [<CommonParameters>]
```

## DESCRIPTION
Public function used to export the Ssis project to a json file that can be used by rest of module.
Not used anywhere by deployment process.
Developers can create project on ssis server and then run this function.
Or we can import older projects into json file.
Written so that we do not have to spend an age creating/updating json file.

## EXAMPLES

### EXAMPLE 1
```
$svr = "Server=.;Integrated Security=True"
$ssisdb = Connect-SsisdbSql -sqlConnectionString $svr
$projectName = "ssis_guy"
$environmentname = "terrain"
$foldername = "ssis_guy"
$desc "here be a description"
$myJsonObject = Get-SsisAsJson -sqlConnection $ssisdb -ssisEnvironment $environmentname -ssisFolder $foldername -ssisProject $projectName -ssisEnvironmentDescription $desc
$myJsonObject | Out-File ".\isc_publish_2.json"
```

## PARAMETERS

### -sqlConnection
Connection to instance that hosts project.

```yaml
Type: SqlConnection
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ssisFolder
Name of the folder we wish to export.

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

### -ssisEnvironment
Name of the environment we wish to export.

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

### -ssisProject
Name of the project we wish to export.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ssisEnvironmentDescription
Description of the environment.
Can be anything

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
