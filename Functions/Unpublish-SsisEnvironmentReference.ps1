function Unpublish-SsisEnvironmentReference {
    <#
.Synopsis
If exists, remove a reference between a project and environment and check it is removed.
.Description
We may wish to remove a reference between an environment and a project.
This function will check if an environment reference exists, and if it does, it will delete it.
Non-mandatory params here can be used to overwrite the values stored in the publish json file passed in
It will verify that it is deleted.
.Parameter jsonPsCustomObject
Tested json object loaded from Import-Json
.Parameter sqlConnection
The SQL Connection to SSISDB
.Parameter ssisFolderName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisEnvironmentName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisProjectName
Optional parameter. We may wish to override the value of what is in the json file.
.Example
Unpublish-SsisEnvironmentReference -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
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
        [String] $ssisEnvironmentName,
        [Parameter(Position = 4, mandatory = $false)]
        [String] $ssisProjectName)

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
    $sqlCheckEnvReferenceIsDeleted = "
SELECT MAX (environment_reference.reference_id)
FROM CATALOG.environment_references environment_reference
WHERE environment_reference.project_id = (
SELECT project.project_id
FROM CATALOG.projects project
INNER JOIN CATALOG.folders folder on folder.folder_id = project.folder_id
WHERE project.NAME = @0
AND folder.NAME = @2
)
AND environment_reference.environment_name = @1"
    try {
        $sqlCommandCheckEnvReferenceDeleted = New-Object System.Data.SqlClient.SqlCommand($sqlCheckEnvReferenceIsDeleted, $sqlConnection)
        $sqlCommandCheckEnvReferenceDeleted.Parameters.AddWithValue("@0", $ssisProperties.ssisProjectName) | Out-Null
        $sqlCommandCheckEnvReferenceDeleted.Parameters.AddWithValue("@1", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCommandCheckEnvReferenceDeleted.Parameters.AddWithValue("@2", $ssisProperties.ssisFolderName) | Out-Null
        $catalogReferenceId = $sqlCommandCheckEnvReferenceDeleted.ExecuteScalar()
    }

    catch {
        Write-Error $_.Exception
    }
    $catalogReferenceIdType = $catalogReferenceId.GetType()
    if ($catalogReferenceIdType.name -ne "Int64") {
        Write-Verbose "There is no reference to delete." -Verbose
        Return;
    }
    $ssisProperties = Add-IscProperty -iscProperties $ssisProperties -ssisPropertyName "catalogReferenceId" -ssisPropertyValue $catalogReferenceId

    $sqlDeleteEnvironmentReference = "
EXEC [catalog].[delete_environment_reference]
@reference_id = @0"
    try {
        $sqlCommandDeleteEnvironmentReference = New-Object System.Data.SqlClient.SqlCommand($sqlDeleteEnvironmentReference, $sqlConnection)
        $sqlCommandDeleteEnvironmentReference.Parameters.AddWithValue("@0", $ssisProperties.catalogReferenceId) | Out-Null
        $sqlCommandDeleteEnvironmentReference.ExecuteNonQuery() | Out-Null
    }
    catch {
        Write-Error $_.Exception
    }
    #check it is deleted
    $sqlCheckEnvReferenceIsDeleted = "
IF NOT EXISTS (
SELECT environment_reference.reference_id
FROM CATALOG.environment_references environment_reference
WHERE environment_reference.project_id = (
SELECT project.project_id
FROM CATALOG.projects project
INNER JOIN CATALOG.folders folder on folder.folder_id = project.folder_id
WHERE project.NAME = @0
AND folder.NAME = @2
)
AND environment_reference.environment_name = @1
)
SELECT 'deleted'"
    try {
        $sqlCommandCheckEnvReferenceDeleted = New-Object System.Data.SqlClient.SqlCommand($sqlCheckEnvReferenceIsDeleted, $sqlConnection)
        $sqlCommandCheckEnvReferenceDeleted.Parameters.AddWithValue("@0", $ssisProperties.ssisProjectName) | Out-Null
        $sqlCommandCheckEnvReferenceDeleted.Parameters.AddWithValue("@1", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCommandCheckEnvReferenceDeleted.Parameters.AddWithValue("@2", $ssisProperties.ssisFolderName) | Out-Null
        [string]$checkEnvironmentReferenceDeleted = $sqlCommandCheckEnvReferenceDeleted.ExecuteScalar()
    }
    catch {
        Write-Error $_.Exception
    }
    if ($checkEnvironmentReferenceDeleted -eq "deleted") {
        $msg = "Environment reference between " + $ssisProperties.ssisProjectName + " and " + $ssisProperties.ssisEnvironmentName + " deleted."
        Write-Verbose $msg -Verbose
    }
}