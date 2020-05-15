function Publish-SsisEnvironmentReference {
    <#
.Synopsis
If it doesn't exist, create a reference between a project and environment and check it exists..
.Description
Create a reference between an environment and a project
We can then associate variables in an environment to parameters in a project
Non-mandatory params here can be used to overwrite the values stored in the publish json file passed in
It will verify that it is created.
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
Publish-SsisEnvironmentReference -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
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
    $sqlPublishEnvironmentReference = "
IF NOT EXISTS (
SELECT 1
FROM CATALOG.environment_references reference
WHERE reference.project_id = (
SELECT project.project_id
FROM CATALOG.projects project
INNER JOIN CATALOG.folders folder ON folder.folder_id = project.folder_id
WHERE project.NAME = @0
AND folder.NAME = @2
)
AND reference.environment_name = @1
)
BEGIN
DECLARE @ssis_reference_id BIGINT

EXEC CATALOG.create_environment_reference @folder_name = @2
,@project_name = @0
,@environment_name = @1
,@reference_type = 'R'
,@reference_id = @ssis_reference_id OUTPUT
END
"
    try {
        $msg = "Checking if a reference exists between " + $ssisProperties.ssisProjectName + " and " + $ssisProperties.ssisEnvironmentName + " exists. If not will create..."
        Write-Verbose $msg -Verbose
        $sqlCmdPublishEnvRef = New-Object System.Data.SqlClient.SqlCommand($sqlPublishEnvironmentReference, $sqlConnection)
        $sqlCmdPublishEnvRef.Parameters.AddWithValue("@0", $ssisProperties.ssisProjectName) | Out-Null
        $sqlCmdPublishEnvRef.Parameters.AddWithValue("@1", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCmdPublishEnvRef.Parameters.AddWithValue("@2", $ssisProperties.ssisFolderName) | Out-Null
        $sqlCmdPublishEnvRef.ExecuteNonQuery() | Out-Null
        Write-Verbose "SQL Script Succeeded. Checking environment reference exists..." -Verbose
    }

    catch {
        Write-Verbose "Creating environment reference failed." -Verbose
        Write-Error $_.Exception
    }
    try {
        $sqlCheckIfEnvironmentReferenceExists = "
SELECT 'exists'
FROM CATALOG.environment_references reference
WHERE reference.project_id = (
SELECT project.project_id
FROM CATALOG.projects project
INNER JOIN CATALOG.folders folder ON folder.folder_id = project.folder_id
WHERE project.NAME = @0
AND folder.NAME = @2
)
AND reference.environment_name = @1
"
        $sqlCmdVerifyEnvRef = New-Object System.Data.SqlClient.SqlCommand($sqlCheckIfEnvironmentReferenceExists, $sqlConnection)
        $sqlCmdVerifyEnvRef.Parameters.AddWithValue("@0", $ssisProperties.ssisProjectName) | Out-Null
        $sqlCmdVerifyEnvRef.Parameters.AddWithValue("@1", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCmdVerifyEnvRef.Parameters.AddWithValue("@2", $ssisProperties.ssisFolderName) | Out-Null
        $checkSsisEnvironmentReferenceExists = [String]$sqlCmdVerifyEnvRef.ExecuteScalar()
        if ($checkSsisEnvironmentReferenceExists -eq "exists") {
            Write-Verbose "Environment reference exists." -Verbose
        }
        else {
            Write-Verbose "Environment Reference does not exist." -Verbose
            Throw;
        }
    }
    catch {
        Write-Error $_.Exception
    }
}