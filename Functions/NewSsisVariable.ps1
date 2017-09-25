

Function New-ssisVariable {
    <#
.Synopsis
Drops Environment variable if it exists and creates an environment variable
.Description
Internal function
Checks if a variable exists, and if it does then it drops and creates a new one.
Used where we need to create a new variable, or where data type and value have changed at same time (easier to drop and re-create when this has occured).
.Parameter sqlConn
connection to SSIS Server
.Parameter ssisVar
The target variable we want to create/re-create
.Parameter ssisProp
The properties (ie folder/project/environment name)
.Example
See PublishSsisVariables for full context
New-SsisVariable -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties            
#>
    [CmdletBinding()]
    param (
        [System.Data.SqlClient.sqlConnection] $sqlConn,
        [PSCustomObject] $ssisVar,
        [hashtable] $ssisProp
    )
    $sqlPublishssisVar = "
IF EXISTS (
    SELECT *
    FROM CATALOG.environment_variables variable
    WHERE variable.environment_id = (
    SELECT environment.environment_id
    FROM CATALOG.environments environment
    INNER JOIN CATALOG.folders folder on folder.folder_id = environment.folder_id
    WHERE environment.NAME = @0
    AND folder.NAME = @2
    )
    AND variable.NAME = @1
    )
    BEGIN
    EXEC CATALOG.delete_environment_variable @folder_name = @2
    ,@environment_name = @0
    ,@variable_name = @1
    END
    EXEC CATALOG.create_environment_variable @folder_name = @2
    ,@environment_name = @0
    ,@variable_name = @1
    ,@data_type = @3
    ,@sensitive = @4
    ,@value = @5
    ,@description = @6"
    Write-Verbose "Creating $($ssisVar.variableName)..." -Verbose
    try {
        $sqlCmdPublishVar = New-Object System.Data.SqlClient.SqlCommand($sqlPublishssisVar, $sqlConn)
        $sqlCmdPublishVar.Parameters.AddWithValue("@0", $ssisProp.ssisEnvironmentName) | Out-Null
        $sqlCmdPublishVar.Parameters.AddWithValue("@1", $($ssisVar.variableName)) | Out-Null
        $sqlCmdPublishVar.Parameters.AddWithValue("@2", $($ssisProp.ssisFolderName)) | Out-Null
        $sqlCmdPublishVar.Parameters.AddWithValue("@3", $($ssisVar.dataType)) | Out-Null
        $sqlCmdPublishVar.Parameters.AddWithValue("@4", $($ssisVar.isSensitive)) | Out-Null
        Switch ($($ssisVar.dataType)) {
            Boolean {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::Bit).Value = [System.Convert]::ToBoolean($($ssisVar.value))}
            Byte {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::TinyInt).Value = ($($ssisVar.value))}
            DateTime {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::DateTime).Value = $($ssisVar.value)}
            Double {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::Float).Value = $($ssisVar.value)}
            Int16 {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::smallint).Value = $($ssisVar.value)}
            Int32 {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::int).Value = $($ssisVar.value)}
            Int64 {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::bigint).Value = $($ssisVar.value)}
            UInt32 {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::Variant).Value = $($ssisVar.value)}
            UInt64 {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::Variant).Value = $($ssisVar.value)}
            Single {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::Real).Value = $($ssisVar.value)}
            String {$sqlCmdPublishVar.Parameters.Add("@5", [System.Data.SqlDbType]::NVarChar).Value = $($ssisVar.value)}
        }
        $sqlCmdPublishVar.Parameters.AddWithValue("@6", $($ssisVar.description)) | Out-Null
        $sqlCmdPublishVar.ExecuteNonQuery() | Out-Null
        Write-Verbose "SQL Script Succeeded. Checking variable exists..." -Verbose
    }
    catch {
        Write-Verbose "Publishing $($ssisVar.variableName) failed." -Verbose
        Write-Error $_.Exception
        Throw
    }
}