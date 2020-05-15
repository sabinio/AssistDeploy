---
external help file: AssistDeploy-help.xml
Module Name: AssistDeploy
online version:
schema: 2.0.0
---

# Test-CurrentPermissions

## SYNOPSIS
Test permissions of current user to verify that htey have the correct permissions to execute deployment.

## SYNTAX

```
Test-CurrentPermissions [-sqlConnection] <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Check that the account running the deployment has the correct permissions to successfully execute a deployment.
If an account is sysadmin then this is very straightforward.
If account is not sysadmin then we check that the minimal permissions have been granted.
Consult the readme for list of permisions, or view the SQLbelow.
Currently the check permissions on the proxy is deactivated.
This will be added at a later date.

## EXAMPLES

### EXAMPLE 1
```
Test-CurrentPermissions -SqlServer $SqlSvr
```

## PARAMETERS

### -sqlConnection
{{ Fill sqlConnection Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
