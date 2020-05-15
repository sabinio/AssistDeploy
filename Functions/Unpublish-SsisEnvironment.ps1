
Function Unpublish-SsisEnvironment {
    <#
.Synopsis
If exists, delete an environment that has been published
.Description
We may wish to remove an environment, especially if an environment is part of a validation that has failed.
This function will check if an environment exists, and if it does, it will delete it.
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
.Example
Unpublish-SsisEnvironment -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
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
        [String] $ssisEnvironmentName)

    $ssisJson = $jsonPsCustomObject
    $ssisProperties = New-IscProperties -jsonObject $ssisJson
    if ($ssisFolderName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisFolderName $ssisFolderName
    }
    if ($ssisEnvironmentName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisEnvironmentName $ssisEnvironmentName
    }

    $sqlUnpublishSsisEnvironment = "
IF EXISTS (
SELECT 1
FROM CATALOG.environments environment
WHERE environment.NAME = @0
AND folder_id = (
SELECT folder.folder_id
FROM CATALOG.folders folder
WHERE folder.NAME = @1
)
)
BEGIN
EXEC CATALOG.delete_environment @1
,@0
END"
    try {
        $msg = "Checking if environment " + $ssisProperties.ssisEnvironmentName + " exists and if so will delete..."
        Write-Verbose $msg -Verbose
        $sqlCommandUnpublishEnvironment = New-Object System.Data.SqlClient.SqlCommand($sqlUnpublishSsisEnvironment, $sqlConnection)
        $sqlCommandUnpublishEnvironment.Parameters.AddWithValue("@0", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCommandUnpublishEnvironment.Parameters.AddWithValue("@1", $ssisProperties.ssisFolderName) | Out-Null
        $sqlCommandUnpublishEnvironment.ExecuteNonQuery() | Out-Null
        Write-Verbose "SQL Script Succeeded. Checking environment deleted..." -Verbose
    }
    catch {
        $msg = "Deleting environment " + $ssisProperties.ssisEnvironmentName + " failed. This is the SQL Statement that failed:"
        Write-Verbose $msg -Verbose
        Write-Verbose $sqlCommandUnpublishEnvironment.CommandText -Verbose
        Write-Error $_.Exception
    }
    try {
        $sqlCheckSsisEnvironmentDeleted = "
IF NOT EXISTS
(   SELECT 'exists'
FROM CATALOG.environments environment
WHERE environment.NAME = @0
AND folder_id = (
SELECT folder.folder_id
FROM CATALOG.folders folder
WHERE folder.NAME = @1
)
)
SELECT 'deleted'"
        $sqlCommandVerifyEnvironment = New-Object System.Data.SqlClient.SqlCommand($sqlCheckSsisEnvironmentDeleted, $sqlConnection)
        $sqlCommandVerifyEnvironment.Parameters.AddWithValue("@0", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCommandVerifyEnvironment.Parameters.AddWithValue("@1", $ssisProperties.ssisFolderName) | Out-Null
        $checkSsisEnvironmentDeleted = [String]$sqlCommandVerifyEnvironment.ExecuteScalar()
        if ($checkSsisEnvironmentDeleted -eq "deleted") {
            $msg = "Environment " + $ssisProperties.ssisEnvironmentName + " deleted."
            Write-Verbose $msg -Verbose
        }
        else {
            $msg = "Environment " + $ssisProperties.ssisEnvironmentName + " still exists."
            Write-Verbose $msg -Verbose
            Throw;
        }
    }
    catch {
        Write-Error $_.Exception
    }
}
