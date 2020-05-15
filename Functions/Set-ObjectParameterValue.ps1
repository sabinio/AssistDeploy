Function Set-ObjectParameterValue {
    <#
.Synopsis
Sets value of parameter to environment variable.
.Description
Sets value of either project or package level parameter to environment variable.
Loops through all params of environment variable.
.Parameter ssisVar
Settings of target variable
.Parameter ssisProp
Properties of deployment (folder/project/environment)
.Example
Set-ObjectParameterValue -sqlConn $sqlConnection -ssisVar $ssisVariable -ssisProp $ssisProperties
#>
    [CmdletBinding()]
    param (
        [System.Data.SqlClient.SqlConnection] $sqlConn,
        [PSCustomObject] $ssisVar,
        [hashtable] $ssisProp
    )
    $ssisParams = $ssisVar.parameter
    ForEach ($ssisParam in $ssisParams) {
        Switch ($ssisParam.parameterType) {
            package {
                $ssisParamTypeValue = 30
                $ssisParamType = $Package
                $ssisObjectName = $ssisParam.objectName
            }
            project {
                $ssisParamTypeValue = 20
                $ssisParamType = $Project
                $ssisObjectName = $ssisProp.ssisProjectName
            }
        }
        $ssisParamName = $ssisParam.parameterName
        if ($null -eq $ssisParamTypeValue) {
            Write-Error "the value of the parameter type for $ssisParamName is neither 'Package' nor 'Project'. Please set accordingly."
            Throw
        }
        $sqlSetObjectParam = "[CATALOG].[set_object_parameter_value]
    @object_type=@5,
    @parameter_name= @0,
    @parameter_value= @4,
    @folder_name= @2,
    @project_name= @3,
    @value_type=R,
    @object_name= @1
    "
        try {
            $msg = "Associating parameter " + $ssisParam.parameterName + " to " + $ssisObjectName + ". Setting value of " + $ssisParamName + " to point to " + $ssisVar.VariableName
            Write-Verbose $msg -Verbose
            $sqlCmdObjParam = New-Object System.Data.SqlClient.SqlCommand($sqlSetObjectParam, $sqlConnection)
            $sqlCmdObjParam.Parameters.AddWithValue("@0", $ssisParamName) | Out-Null
            $sqlCmdObjParam.Parameters.AddWithValue("@4", $ssisVar.VariableName) | Out-Null
            $sqlCmdObjParam.Parameters.AddWithValue("@2", $ssisProp.ssisFolderName) | Out-Null
            $sqlCmdObjParam.Parameters.AddWithValue("@3", $ssisProp.ssisProjectName) | Out-Null
            $sqlCmdObjParam.Parameters.AddWithValue("@5", $ssisParamTypeValue) | Out-Null
            $sqlCmdObjParam.Parameters.AddWithValue("@1", $ssisObjectName) | Out-Null
            $sqlCmdObjParam.ExecuteNonQuery() | Out-Null
        }
        catch {
            Write-Verbose "Setting package variables to environment variables failed." -Verbose
            Write-Error $_.Exception
            Throw
        }
    }
}