Function Set-EnvironmentVariableProperty {
        <#
.Synopsis
Set the given property to a given value
.Description
Updates a given property to a given value - if data type has been altered then we parameterName will be "Type". 
If description altered then "description". These are the only two properties that can be altered.
.Parameter ssisVar
Settings of target variable
.Parameter ssisProp
Properties of deployment (folder/project/environment)
.Parameter PropertyName
Either description or type.
.Parameter ProeprtyValue
new value.
.Example
Set-EnvironmentVariableProperty -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties -PropertyName "Description" -PropertyValue $ssisVariable.Description
Set-EnvironmentVariableProperty -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties -PropertyName "Type" -PropertyValue $ssisVariable.dataType
#>
    [CmdletBinding()]
    param (
        [System.Data.SqlClient.SqlConnection] $sqlConn,
        [PSCustomObject] $ssisVar,
        [hashtable] $ssisProp,
        [String] $PropertyName,
        [String] $PropertyValue
    )
    $sqlSetSsisVarProp = "
    [CATALOG].[set_environment_variable_protection] 
    @folder_name = @0,
    @environment_name = @1, 
    @variable_name = @2,
    @property_name = @3,
    @property_value = @4 
        "
    try {
        $sqlCmdVarVProp = New-Object System.Data.SqlClient.SqlCommand($sqlSetSsisVarProp, $sqlConn)
        $sqlCmdVarVProp.Parameters.AddWithValue("@0", $ssisProp.ssisFolderName) | Out-Null
        $sqlCmdVarVProp.Parameters.AddWithValue("@1", $ssisProp.ssisEnvironmentName) | Out-Null
        $sqlCmdVarVProp.Parameters.AddWithValue("@2", $ssisVar.variableName) | Out-Null
        $sqlCmdVarVProp.Parameters.AddWithValue("@3", $PropertyName) | Out-Null
        $sqlCmdVarVProp.Parameters.AddWithValue("@4", $PropertyValue) | Out-Null
        $sqlCmdVarVProp.ExecuteNonQuery() | Out-Null
        Write-Verbose "Updated property $PropertyName of environment variable $($ssisVar.variableName)." -Verbose
    }
    catch {
        Write-Verbose "Publishing $($ssisVar.variableName) failed." -Verbose
        Write-Error $_.Exception
        Throw
    }
}