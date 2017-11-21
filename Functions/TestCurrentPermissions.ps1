Function Test-CurrentPermissions {
    <#
.Synopsis
Test permissions of current user to verify that htey have the correct permissions to execute deployment.
.Description
Check that the account running the deployment has the correct permissions to successfully execute a deployment.
If an account is sysadmin then this is very straightforward.
If account is not sysadmin then we check that the minimal permissions have been granted. Consult the readme for list of permisions, or view the SQLbelow.
Currently the check permissions on the proxy is deactivated. This will be added at a later date. 
.Parameter SqlServer
The SQL Instance we are deploying to.
.Example
Test-CurrentPermissions -SqlServer $SqlSvr
#>
    param(
        [Parameter(Position = 1, mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] $sqlConnection
    )
    $domain = [Environment]::UserDomainName
    $uname = [Environment]::UserName
    [string]$whoAmI = "$domain\$uname"
    $sqlQuerySysAdmin = "SELECT IS_SRVROLEMEMBER('sysadmin') as 'AmISysAdmin';"
    $sqlCommandSysAdmin = New-Object System.Data.SqlClient.SqlCommand($sqlQuerySysAdmin, $sqlConnection)
    $SQLSysAdminPermissions = [String]$sqlCommandSysAdmin.ExecuteScalar()
    if ($SQLSysAdminPermissions -eq 1) {
        Write-Verbose "User $whoAmI is sysadmin on instance. No further checks required!" -Verbose
        return
    }
    else {
        $sqlQueryRole = "SELECT IS_ROLEMEMBER('ssis_admin') AS 'ssis_admin';"
        $sqlCommandRole = New-Object System.Data.SqlClient.SqlCommand($sqlQueryRole, $sqlConnection)
        $SQLIsRoleMember = [String]$sqlCommandRole.ExecuteScalar()
        Write-Verbose $SQLIsRoleMember -Verbose
        if ($SQLIsRoleMember -ne 1) {
            Throw "$WhoAmI is not a member of the ssis_admin role in SSISDB."
        }
    }
}