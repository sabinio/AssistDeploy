Function Set-EnvironmentVariableValue {
<#
.Synopsis
Updates value of variable
.Description
Updates value of varialbe on server to what it is in target
.Parameter ssisVar
Settings of target variable
.Parameter ssisProp
Properties of deployment (folder/project/environment)
new value.
.Example
Set-EnvironmentVariableValue -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties 
#>
    [CmdletBinding()]
    param (
        [System.Data.SqlClient.SqlConnection] $sqlConn,
        [PSCustomObject] $ssisVar,
        [hashtable] $ssisProp
    )
    $sqlSetSsisVar = "
    [CATALOG].[set_environment_variable_value] 
     @folder_name = @2
    ,@environment_name = @0  
    ,@variable_name = @1  
    ,@value =@3 
        "
        try {
            $sqlCmdVarValue = New-Object System.Data.SqlClient.SqlCommand($sqlSetSsisVar, $sqlConn)
            $sqlCmdVarValue.Parameters.AddWithValue("@0", $ssisProp.ssisEnvironmentName) | Out-Null
            $sqlCmdVarValue.Parameters.AddWithValue("@1", $ssisVar.variableName) | Out-Null
            $sqlCmdVarValue.Parameters.AddWithValue("@2", $ssisProp.ssisFolderName) | Out-Null
            $sqlCmdVarValue.Parameters.AddWithValue("@3", $ssisvar.value) | Out-Null
            $sqlCmdVarValue.ExecuteNonQuery() | Out-Null
            Write-Verbose "Updated value of environment variable $($ssisVar.variableName)." -Verbose
        }
        catch {
            Write-Verbose "Publishing $($ssisVar.variableName) failed." -Verbose
            Write-Error $_.Exception
            Throw
        }
}