---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Disconnect-SsisdbSql

## SYNOPSIS
dispose of a connection to sql instance

## SYNTAX

```
Disconnect-SsisdbSql [-sqlConnection] <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Using sqldataclient.sqlconnection, dispose a connection to sql instance
Dispose method also calls close, so it return connection back to the pool
State of conection can be open, closed, broken, connecting, executing, fetching

## EXAMPLES

### EXAMPLE 1
```
$mySqlConnection = "Server=.;Integrated Security=True"
Disconnect-SsisdbSql -sqlConnection $mySqlConnection
```

## PARAMETERS

### -sqlConnection
The connection we wish to dispose of.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
