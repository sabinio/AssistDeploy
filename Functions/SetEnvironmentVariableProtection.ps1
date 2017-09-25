Function Set-EnvironmentVariableProtection {
            <#
.Synopsis
Alters protection level of variable
.Description
Alters protection level of variable... IDK what else to say
.Parameter ssisVar
Settings of target variable
.Parameter ssisProp
Properties of deployment (folder/project/environment)
new value.
.Example
 Set-EnvironmentVariableProtection -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties
 #>
    [CmdletBinding()]
    param (
        [System.Data.SqlClient.SqlConnection] $sqlConn,
        [PSCustomObject] $ssisVar,
        [hashtable] $ssisProp
    )
    $sqlSetSsisVarPro = "
    [CATALOG].[set_environment_variable_protection] 
     @folder_name = @2
    ,@environment_name = @0  
    ,@variable_name = @1  
    ,@sensitive =@3 
        "
        try {
            $sqlCmdVarVPro = New-Object System.Data.SqlClient.SqlCommand($sqlSetSsisVarPro, $sqlConn)
            $sqlCmdVarVPro.Parameters.AddWithValue("@0", $ssisProp.ssisEnvironmentName) | Out-Null
            $sqlCmdVarVPro.Parameters.AddWithValue("@1", $ssisVar.variableName) | Out-Null
            $sqlCmdVarVPro.Parameters.AddWithValue("@2", $ssisProp.ssisFolderName) | Out-Null
            $sqlCmdVarVPro.Parameters.AddWithValue("@3", $ssisvar.isSensitive) | Out-Null
            $sqlCmdVarVPro.ExecuteNonQuery() | Out-Null
            Write-Verbose "Updated protection level of environment variable $($ssisVar.variableName) to $($ssisvar.isSensitive)." -Verbose
        }
        catch {
            Write-Verbose "Publishing $($ssisVar.variableName) failed." -Verbose
            Write-Error $_.Exception
            Throw
        }
}