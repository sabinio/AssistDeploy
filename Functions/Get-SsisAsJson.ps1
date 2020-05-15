Function Get-SsisAsJson {
    <#
.Synopsis
Convert Ssis project and parameters as json object.
.Description
Public function used to export the Ssis project to a json file that can be used by rest of module.
Not used anywhere by deployment process.
Developers can create project on ssis server and then run this function.
Or we can import older projects into json file.
Written so that we do not have to spend an age creating/updating json file.
.Parameter sqlConnection
Connection to instance that hosts project.
.Parameter ssisFolder
Name of the folder we wish to export.
.Parameter ssisEnvironment
Name of the environment we wish to export.
.Parameter ssisProject
Name of the project we wish to export.
.Parameter ssisEnvironmentDescription
Description of the environment. Can be anything
.Example
$svr = "Server=.;Integrated Security=True"
$ssisdb = Connect-SsisdbSql -sqlConnectionString $svr
$projectName = "ssis_guy"
$environmentname = "terrain"
$foldername = "ssis_guy"
$desc "here be a description"
$myJsonObject = Get-SsisAsJson -sqlConnection $ssisdb -ssisEnvironment $environmentname -ssisFolder $foldername -ssisProject $projectName -ssisEnvironmentDescription $desc
$myJsonObject | Out-File ".\isc_publish_2.json"
#>
    param
    (
        [Parameter(Position = 0, mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] $sqlConnection,
        [Parameter(Position = 1, mandatory = $true)]
        [String] $ssisFolder,
        [Parameter(Position = 2, mandatory = $true)]
        [String] $ssisEnvironment,
        [Parameter(Position = 3, mandatory = $true)]
        [String] $ssisProject,
        [Parameter(Position = 4, mandatory = $true)]
        [String] $ssisEnvironmentDescription
    )
    $ssisjsonProperties = @{IntegrationServicesCatalog = @{
            'ssisFolderName'             = $ssisFolder;
            'ssisEnvironmentName'        = $ssisEnvironment;
            'ssisProjectName'            = $ssisProject;
            'ssisEnvironmentDescription' = $ssisEnvironmentDescription
        }
        'SsisEnvironmentVariable'                      = @()
    }

    $sqlQueryWhatIsVars = '
    ;
    
    WITH cte
    AS (
        SELECT referenced_variable_name
        FROM CATALOG.object_parameters p
        WHERE project_id = (
                SELECT project_id
                FROM CATALOG.projects proj
                WHERE proj.NAME = @0
                    AND proj.folder_id = (
                        SELECT folder.folder_id
                        FROM CATALOG.folders folder
                        WHERE folder.NAME = @2
                            AND folder.folder_id = (
                                SELECT environment.folder_id
                                FROM CATALOG.environments environment
                                WHERE environment.NAME = @1
                                )
                        )
                )
        )
    SELECT referenced_variable_name 
    FROM cte
    WHERE cte.referenced_variable_name IN (
            SELECT NAME
            FROM CATALOG.environment_variables
            )
    '
    try {
        $sqlCmdWhatIsVars = New-Object System.Data.SqlClient.SqlCommand($sqlQueryWhatIsVars, $sqlConnection)
        $sqlCmdWhatIsVars.Parameters.AddWithValue("@0", $ssisProject) | Out-Null
        $sqlCmdWhatIsVars.Parameters.AddWithValue("@1", $ssisEnvironment) | Out-Null
        $sqlCmdWhatIsVars.Parameters.AddWithValue("@2", $ssisFolder) | Out-Null
        $sqlWhatisDataAdapter = New-Object System.Data.SqlClient.SqlDataAdapter $sqlCmdWhatIsVars
        $sqlWhatIsDataSet = New-Object System.Data.DataSet
        $sqlWhatisDataAdapter.Fill($sqlWhatIsDataSet) | Out-Null
        $sqlWhatIsDataTable = $sqlWhatIsDataSet.Tables[0]
        $referencedVariableNames = @()
        foreach ($row in $sqlWhatIsDataTable.Rows) { 
            $referencedVariableNames += $row.referenced_variable_name
        }
    }
    catch {
        throw $_.Exception
    }
    Write-Verbose "$($referencedVariableNames.Count) Variables found. Finding params..." -Verbose
    foreach ($var in $referencedVariableNames) {
        Write-Verbose $var -Verbose 
        $sqlSsisVariable = "SELECT eevee.NAME
        ,eevee.type
        ,eevee.sensitive
        ,eevee.value
        ,eevee.description
    FROM CATALOG.environment_variables eevee
    WHERE eevee.NAME = @0
        AND eevee.environment_id = (
            SELECT environment.environment_id
            FROM CATALOG.environments environment
            INNER JOIN catalog.folders folder on folder.folder_id = environment.folder_id
			INNER JOIN catalog.projects project on project.folder_id = folder.folder_id
            WHERE environment.NAME = @1
            AND folder.NAME = @2
			AND project.NAME = @3
            )
        "
        try {
            $sqlCmdVar = New-Object System.Data.SqlClient.SqlCommand($sqlSsisVariable, $sqlConnection)
            $sqlCmdVar.Parameters.AddWithValue("@0", $var) | Out-Null
            $sqlCmdVar.Parameters.AddWithValue("@1", $ssisEnvironment) | Out-Null
            $sqlCmdVar.Parameters.AddWithValue("@2", $ssisFolder) | Out-Null
            $sqlCmdVar.Parameters.AddWithValue("@3", $ssisProject) | Out-Null
            $sqlVarAdapter = New-Object System.Data.SqlClient.SqlDataAdapter $sqlCmdVar
            $sqlVarDataset = New-Object System.Data.DataSet
            $sqlVarAdapter.Fill($sqlVarDataset) | Out-Null
            $sqlVarDataTable = $sqlVarDataSet.Tables[0]
            for ($i = 0; $i -lt $sqlVarDataTable.Rows.Count; $i++) { 
                $splat = @{
                    'VariableName' = $sqlVarDataTable.Rows[$i][0]
                    'dataType'     = $sqlVarDataTable.Rows[$i][1]
                    'isSensitive'  = $sqlVarDataTable.Rows[$i][2]
                    'value'        = $sqlVarDataTable.Rows[$i][3]
                    'description'  = $sqlVarDataTable.Rows[$i][4]
                    'parameter'    = @()
                }
            }
            $sqlSsisParam = "SELECT obj_param.object_type
                ,obj_param.object_name
                ,obj_param.parameter_name
                ,obj_param.referenced_variable_name
            FROM CATALOG.object_parameters obj_param
            WHERE obj_param.referenced_variable_name = @3
                AND obj_param.project_id = (
                    SELECT proj.project_id
                    FROM CATALOG.projects proj
                    WHERE proj.NAME = @1
                        AND proj.folder_id = (
                            SELECT folder.folder_id
                            FROM CATALOG.folders folder
                            WHERE folder.NAME = @2
                            )
                    )
                "
            $sqlSsisParamCmd = New-Object System.Data.SqlClient.SqlCommand($sqlSsisParam, $sqlConnection)
            $sqlSsisParamCmd.Parameters.AddWithValue("@1", $ssisProject) | Out-Null
            $sqlSsisParamCmd.Parameters.AddWithValue("@2", $ssisFolder) | Out-Null
            $sqlSsisParamCmd.Parameters.AddWithValue("@3", $var) | Out-Null
            $sqlParamAdapter = New-Object System.Data.SqlClient.SqlDataAdapter $sqlSsisParamCmd
            $sqlParamDataset = New-Object System.Data.DataSet
            $sqlParamAdapter.Fill($sqlParamDataset) | Out-Null
            $sqlParamDataTable = $sqlParamDataset.Tables[0] 
            if ($sqlParamDatatable.Rows.Count -gt 0) {
                for ($i = 0; $i -lt $sqlParamDatatable.Rows.Count; $i++) {
                    Write-Verbose "Params for $var found: $($sqlParamDataTable.Rows[$i][2])." -Verbose
                    if ($sqlParamDataTable.Rows[$i][0] -eq 20) {
                        $paramType = "project"
                        $splat2 = @{
                            'parameterType' = $paramType
                            'parameterName' = $sqlParamDataTable.Rows[$i][2]
                        }
                    }
                    else {
                        $paramType = "package"
                        $splat2 = @{
                            'parameterType' = $paramType
                            'objectName'    = $sqlParamDataTable.Rows[$i][1]
                            'parameterName' = $sqlParamDataTable.Rows[$i][2]
                        }
                    }
                    $splat.parameter += $splat2
                    Remove-Variable -Name splat2
                }
            }
            Clear-Variable sqlParam*
            $ssisjsonProperties.SsisEnvironmentVariable += $splat
        }
        catch {
            Write-Error $_.Exception
        }
        Clear-Variable sqlVar*
    }
    Write-Verbose "Converting to Json..." -Verbose
    $ssisJson = ConvertTo-Json $ssisjsonProperties -Depth 10
    return $ssisJson
}