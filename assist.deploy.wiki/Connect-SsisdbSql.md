---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Connect-SsisdbSql

## SYNOPSIS
create a connection to sql instance

## SYNTAX

```
Connect-SsisdbSql [-sqlConnectionString] <String> [<CommonParameters>]
```

## DESCRIPTION
Using sqldataclient.sqlconnection, create a connection to sql instance
Set database to ssisdb
return connection

## EXAMPLES

### EXAMPLE 1
```
Connect-SsisdbSql -sqlConnectionString "Server=.;Integrated Security=True"
```

## PARAMETERS

### -sqlConnectionString
The SQL Connection as a string that we use to make object SqlConnection

```yaml
Type: String
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
