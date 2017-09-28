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
            Switch ($($ssisVar.dataType)) {
                Boolean {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Bit).Value = [System.Convert]::ToBoolean($($ssisVar.value))| Out-Null}
                Byte {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::TinyInt).Value = ($($ssisVar.value))| Out-Null} 
                DateTime {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::DateTime).Value = $($ssisVar.value)| Out-Null}
                Double {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Float).Value = $($ssisVar.value) | Out-Null} 
                Int16 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::smallint).Value = $($ssisVar.value)| Out-Null}
                Int32 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::int).Value = $($ssisVar.value)| Out-Null}
                Int64 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::bigint).Value = $($ssisVar.value)| Out-Null}
                UInt32 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Variant).Value = $($ssisVar.value)| Out-Null}
                UInt64 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Variant).Value = $($ssisVar.value)| Out-Null}
                Single {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Real).Value = $($ssisVar.value)| Out-Null}
                String {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::NVarChar).Value = $($ssisVar.value)| Out-Null}
            }
            $sqlCmdVarValue.ExecuteNonQuery() | Out-Null
            Write-Verbose "Updated value of environment variable $($ssisVar.variableName)." -Verbose
        }
        catch {
            Write-Verbose "Publishing $($ssisVar.variableName) failed." -Verbose
            Write-Error $_.Exception
            Throw
        }
}