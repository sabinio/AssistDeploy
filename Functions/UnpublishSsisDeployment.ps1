function Unpublish-SsisDeployment {
    <#
.Synopsis
Rollback ispac deployment: reverts to previous version of deployed project.
.Description
If a validate project has failed and we wish to rollback we needto revert to previous working project
First it checks that you can rollback (ie previous versions are stored)
.Parameter jsonPsCustomObject
Tested json object loaded from Import-Json
.Parameter sqlConnection
The SQL Connection to SSISDB
.Parameter ssisFolderName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisProjectName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisProjectLsn
Retrieved from ISC by using Get-SsisProjectLsn function.
.Parameter Delete
Optional parameter. Will delete a project. Can be used when there is no project version to roll back to. Or can be used as a nucelar option.
.Example
$ssisLatestProjectLsn = Get-SsisProjectLsn -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
do deployment....
do validation...
validation fails...
if ($null -eq $ssisLatestProjectLsn) {
Unpublish-SsisDeployment -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -ssisProjectLsn $ssisLatestProjectLsn
}
else {
Unpublish-SsisDeployment -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -delete
}
#>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [PSCustomObject] $jsonPsCustomObject,
        [Parameter(Position = 1, mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] $sqlConnection,
        [Parameter(Position = 2, mandatory = $false)]
        [String] $ssisFolderName,
        [Parameter(Position = 3, mandatory = $false)]
        [String] $ssisProjectName,
        [Parameter(Position = 4, mandatory = $false)]
        [String] $ssisProjectLsn,
        [Parameter(Position = 5, mandatory = $false)]
        [Switch] $delete)

    $ssisJson = $jsonPsCustomObject
    $ssisProperties = New-IscProperties -jsonObject $ssisJson
    if ($ssisFolderName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisFolderName $ssisFolderName
    }
    if ($ssisProjectName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisProjectName $ssisProjectName
    }
    if ($ssisProjectLsn) {
        $ssisProperties = Add-IscProperty -iscProperties $ssisProperties -ssisPropertyName "ssisPreviousVersionLsn" -ssisPropertyValue $ssisProjectLsn
    }
    if ($delete) {
        $sqlDeleteProject = "DECLARE	@return_value int
EXEC	@return_value = [catalog].[delete_project]
@folder_name = N@0,
@project_name = N@1
SELECT	@return_value"
        $sqlCommandDeleteProject = New-Object System.Data.SqlClient.SqlCommand($sqlDeleteProject, $sqlConnection)
        $sqlCommandDeleteProject.Parameters.Add("@0", $ssisProperties.ssisFolderName) | Out-Null
        $sqlCommandDeleteProject.Parameters.Add("@1", $ssisProperties.ssisProjectName) | Out-Null
        try {
            $ssisDeleteReturnValue = $sqlCommandDeleteProject.ExecuteScalar()
        }
        catch {
            Write-Error "Something has gone wrong."
            Throw;
        }
        Write-Verbose $ssisDeleteReturnValue -Verbose
        if ($ssisDeleteReturnValue -ne 0) {
            Write-Error "Something has gone wrong"
            Throw;
        }
        Write-Verbose "Deletion successful." -Verbose
        Return
    }
    else {
        $sqlPropertyValue = "SELECT property_value
FROM CATALOG.catalog_properties properties
WHERE properties.property_name = 'MAX_PROJECT_VERSIONS'"
        $sqlCommandGetPropertyValue = New-Object System.Data.SqlClient.SqlCommand($sqlPropertyValue, $sqlConnection)
        $ssisPropertyMaxVersions = $sqlCommandGetPropertyValue.ExecuteScalar()
        if ($ssisPropertyMaxVersions -le 1) {
            Write-Error "MAX PROJECTVERSIONS is below the minimum amount to rollback Project.
Increase Max Project Versions on SSIS Catalog Properties to enable
storing older versions of a project."
        }
        $msg = "Rolling back project " + $ssisProperties.ssisProjectName + " to " + $ssisProperties.ssisPreviousVersionLsn
        Write-Verbose $msg -Verbose

        $sqlRestoreProject = "DECLARE	@return_value int
EXEC	@return_value = [catalog].[restore_project]
@folder_name = @0,
@project_name = @1,
@object_version_lsn = @2
SELECT @return_value"
        $sqlCommandRestoreProject = New-Object System.Data.SqlClient.SqlCommand($sqlRestoreProject, $sqlConnection)
        $sqlCommandRestoreProject.Parameters.Add("@0", $ssisProperties.ssisFolderName) | Out-Null
        $sqlCommandRestoreProject.Parameters.Add("@1", $ssisProperties.ssisProjectName) | Out-Null
        $sqlCommandRestoreProject.Parameters.Add("@2", $ssisProperties.ssisPreviousVersionLsn) | Out-Null
        try {
            $ssisRollbackReturnValue = $sqlCommandRestoreProject.ExecuteScalar()
        }
        catch {
            Write-Error "Something has gone wrong."
            Throw;
        }
        Write-Verbose $ssisRollbackReturnValue -Verbose
        if ($ssisRollbackReturnValue -ne 0) {
            Write-Error "Something has gone wrong"
            Throw;
        }
        Write-Verbose "Rollback successful." -Verbose
        Write-Warning "When a project is rolled back, all parameters are assigned default values and all environment references remain unchanged."
        Write-Warning "Environment references may no longer be valid after a project has been rolled back."
    }
}