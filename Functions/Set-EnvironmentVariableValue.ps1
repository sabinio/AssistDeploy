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
                Boolean {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Bit).Value = [System.Convert]::ToBoolean($($ssisVar.value))}
                Byte {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::TinyInt).Value = ($ssisVar.value)} 
                DateTime {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::DateTime).Value = $($ssisVar.value)}
                Double {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Float).Value = $($ssisVar.value) } 
                Int16 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::smallint).Value = $($ssisVar.value)}
                Int32 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::int).Value = $($ssisVar.value)}
                Int64 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::bigint).Value = $($ssisVar.value)}
                UInt32 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Variant).Value = $($ssisVar.value)}
                UInt64 {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Variant).Value = $($ssisVar.value)}
                Single {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Real).Value = $($ssisVar.value)}
                String {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::NVarChar).Value = $($ssisVar.value)}
                Decimal {$sqlCmdVarValue.Parameters.Add("@3", [System.Data.SqlDbType]::Decimal).Value = $($ssisVar.value)}
                Default {"Data type for $($ssisVar.variableName) is not currently supported. Either contact developer of module or alter Set-EnvironmentVariableValue Function to support data type $($ssisVar.dataType)."
                Throw}
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