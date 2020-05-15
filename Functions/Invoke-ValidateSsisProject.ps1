Function Invoke-ValidateSsisProject {
    <#
.Synopsis
After a deployment of the folder/environment/variables/ispac/environment reference, run a validate project.
.Description
We may wish to validate that the dtsx packages in a project will run successfully
This function will run a validation and return a validation status.
Any validation status other than 7 means something has gone wrong.
The function checks the status itself and will return an error if status is not 7.
We can use the output from this function to run other functions to rollback deployment (ie if $status -ne "suceeded")
{
Unpublish-SsisDeployment
undo-ssisEnvironmentReference
Unpublish-SsisEnvironment
Edit-SsisEnvironmentName
}
This assumes you have run "unpublish-environmentReference" and "edit-ssisEnvironmentName" prior to deployment
I am not a huge fan of roling back, but the functionality exists in this module if people want to use it.
.Parameter jsonPsCustomObject
Tested json object loaded from Import-Json
.Parameter sqlConnection
The SQL Connection to SSISDB
.Parameter ssisFolderName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisProjectName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisEnvironmentName
Optional parameter. We may wish to override the value of what is in the json file.
.Example
$validationStatus = Invoke-ValidateSsisProject -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
#>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [PSCustomObject] $jsonPsCustomObject,
        [Parameter(Position = 1, mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] $sqlConnection,
        [Parameter(Position = 2, mandatory = $false)]
        [string] $ssisFolderName,
        [Parameter(Position = 3, mandatory = $false)]
        [string] $ssisProjectName,
        [Parameter(Position = 4, mandatory = $false)]
        [string] $ssisEnvironmentName)

    $ssisJson = $jsonPsCustomObject
    $ssisProperties = New-IscProperties -jsonObject $ssisJson
    if ($ssisFolderName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisFolderName $ssisFolderName
    }
    if ($ssisEnvironmentName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisEnvironmentName $ssisEnvironmentName
    }
    if ($ssisProjectName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisProjectName $ssisProjectName
    }

    $sqlSsisValidateProject = "
DECLARE @validation_id BIGINT
DECLARE @ssis_environment_reference_id BIGINT

SELECT @ssis_environment_reference_id = reference_id
FROM CATALOG.environment_references reference
WHERE reference.project_id = (
SELECT project.project_id
FROM CATALOG.projects project
INNER JOIN CATALOG.environments environment ON environment.folder_id = project.folder_id
INNER JOIN CATALOG.folders folder ON folder.folder_id = project.folder_id
WHERE project.NAME = @0
AND environment.NAME = @1
AND folder.NAME = @2
)
AND reference.environment_name = @1
DECLARE @validation_return_code BIGINT

EXEC CATALOG.validate_project @folder_name = @2
,@project_name = @0
,@validate_type = 'F'
,@validation_id = @validation_id OUTPUT
,@environment_scope = 'S'
,@reference_id = @ssis_environment_reference_id
SELECT @validation_id"
    try {
        $msg = "Validating project " + $ssisProperties.ssisProjectName + " and " + $ssisProperties.ssisEnvironmentName 
        Write-Verbose $msg -Verbose
        $sqlCmdValidate = New-Object System.Data.SqlClient.SqlCommand($sqlSsisValidateProject, $sqlConnection)
        $sqlCmdValidate.Parameters.Add("@0", $ssisProperties.ssisProjectName) | Out-Null
        $sqlCmdValidate.Parameters.Add("@1", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCmdValidate.Parameters.Add("@2", $ssisProperties.ssisFolderName) | Out-Null
        $sqlValidationId = $sqlCmdValidate.ExecuteScalar()
    }

    catch {
        Write-Verbose "Validating project failed:" -Verbose
        Write-Verbose $sqlCmdValidate.CommandText -Verbose
        Write-Error $_.Exception
    }
    finally {
        $validationStatus = $null
        $sqlSsisValidateProject = "
SELECT validation.STATUS
FROM CATALOG.validations validation
WHERE validation.validation_id = @3
AND STATUS NOT IN (
1
,2
,5
,8
,9
)"
        $sqlCmdValidate.CommandText = $sqlSsisValidateProject
        $sqlCmdValidate.Parameters.Add("@3", $sqlValidationId) | Out-Null
        do {
            Start-Sleep -Seconds 5
            try {
                $validationStatus = $sqlCmdValidate.ExecuteScalar()
            }
            catch {
                Write-Error $_.Exception
            }
        }
        until ($validationStatus -ne $null)
        Switch ($validationStatus) {
            1 {$statusValue = "created"}
            2 {$statusValue = "running"}
            3 {$statusValue = "canceled"}
            4 {$statusValue = "failed"}
            5 {$statusValue = "pending"}
            6 {$statusValue = "ended unexpectedly"}
            7 {$statusValue = "succeeded"}
            8 {$statusValue = "stopping"}
            9 {$statusValue = "completed"}
        }
        Write-Verbose "Validating project has finished. The status of the validation is $statusValue" -Verbose
        $sqlCommandGetEventMessages = "
SELECT eevee.event_message_id
,eevee.message
,eevee.event_name
,eevee.message_source_name
,eevee.subcomponent_name
,eevee.package_path
,eevee.execution_path
FROM [catalog].[event_messages] eevee
WHERE eevee.operation_id = @4
ORDER BY eevee.event_message_id ASC"
        $sqlCmdValidate.CommandText = $sqlCommandGetEventMessages
        $sqlCmdValidate.Parameters.Add("@4", $sqlValidationId) | Out-Null
        $adp = New-Object System.Data.SqlClient.SqlDataAdapter
        $sqlDataTable = New-Object System.Data.DataTable
        $adp.SelectCommand = $sqlCmdValidate
        try {
            $adp.Fill($sqlDataTable) | Out-Null
        }
        catch {
            Write-Error $_.Exception
        }
        finally {
            foreach ($row in $sqlDataTable.Rows) {
                $msg = $row.Item(1) + $row.Item(2) + $row.Item(3)
                Write-Verbose $msg -Verbose
            }
            #Write-Verbose $msg -Verbose
        }
    }
    $ValidationResult = @()
    $ValidationResult += New-Object -TypeName psobject -Property @{'statusValue' = "$($statusValue)";
        'validationStatus' = "$($validationStatus)"
    }
    Return $ValidationResult
}