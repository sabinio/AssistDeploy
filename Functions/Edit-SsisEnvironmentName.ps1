
Function Edit-SsisEnvironmentName {
    <#
.Synopsis
This executes the stored procedure "rename environment", effectively appending the current SSIS Project LSN to the name.
.Description
Before we re-write the values stored in an environment, we can effectively take a back up of the current environment by re-naming it.
We can used the return name to revert this back to the original name if we need to rollback if a validation has failed
.Parameter jsonPsCustomObject
Tested json object loaded from Import-Json
.Parameter sqlConnection
The SQL Connection to SSISDB
.Parameter ssisFolderName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisEnvironmentName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisProjectLsn
Retrieved from ISC by using Get-SsisProjectLsn function.
.Example
$ssisEnvironmentRename = Edit-SsisEnvironmentName -ssisPublishFilePath $thisSsisPublishFilePath -ssisProjectLsn $thisLsn -sqlConnection $ssisdb
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
        [Parameter(Position = 4, mandatory = $true)]
        [String] $ssisProjectLsn)

    $ssisJson = $jsonPsCustomObject
    $ssisProperties = New-IscProperties -jsonObject $ssisJson
    if ($ssisFolderName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisFolderName $ssisFolderName
    }
    if ($ssisEnvironmentName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisEnvironmentName $ssisEnvironmentName
    }

    $ssisNewEnvironmentName = $ssisProperties.ssisEnvironmentName + "" + $ssisProjectLsn

    $ssisProperties = Add-IscProperty -iscProperties $ssisProperties -ssisPropertyName "ssisNewEnvironmentName" -ssisPropertyValue $ssisNewEnvironmentName

    $sqlRenameEnvironment = "
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
EXEC CATALOG.rename_environment @1
,@0
,@2
END"
    try {
        $msg = "Hi! Renaming environment " + $ssisProperties.ssisEnvironmentName + " to " + $ssisProperties.ssisNewEnvironmentName + "..."
        Write-Verbose $msg -Verbose
        $sqlCommandRenameEnvironment = New-Object System.Data.SqlClient.SqlCommand($sqlRenameEnvironment, $sqlConnection)
        $sqlCommandRenameEnvironment.Parameters.AddWithValue("@0", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCommandRenameEnvironment.Parameters.AddWithValue("@1", $ssisProperties.ssisFolderName) | Out-Null
        $sqlCommandRenameEnvironment.Parameters.AddWithValue("@2", $ssisProperties.ssisNewEnvironmentName) | Out-Null
        $sqlCommandRenameEnvironment.ExecuteNonQuery() | Out-Null
        Write-Verbose "SQL Script Succeeded. Checking environment exists..." -Verbose
    }
    catch {
        Write-Error $_.Exception
    }
    try {
        $sqlCheckSsisEnvironmentExists = "
SELECT 'exists'
FROM CATALOG.environments environment
WHERE environment.NAME = @0
AND folder_id = (
SELECT folder.folder_id
FROM CATALOG.folders folder
WHERE folder.NAME = @1
)"
        $sqlCommandVerifyEnvironment = New-Object System.Data.SqlClient.SqlCommand($sqlCheckSsisEnvironmentExists, $sqlConnection)
        $sqlCommandVerifyEnvironment.Parameters.AddWithValue("@0", $ssisProperties.ssisNewEnvironmentName) | Out-Null
        $sqlCommandVerifyEnvironment.Parameters.AddWithValue("@1", $ssisProperties.ssisFolderName) | Out-Null
        $checkSsisEnvironmentExists = [String]$sqlCommandVerifyEnvironment.ExecuteScalar()
        if ($checkSsisEnvironmentExists -eq "exists") {
            $msg = "Environment " + $ssisProperties.ssisNewEnvironmentName + " exists and renamed successfully."
            Write-Verbose $msg -Verbose
        }
        else {
            $msg = "Environment " + $ssisProperties.ssisNewEnvironmentName + " does not exist."
            Write-Verbose $msg -Verbose
            $ssisProperties.ssisNewEnvironmentName = $null
        }
    }
    catch {
        Write-Error $_.Exception
    }
    Return $ssisProperties.ssisNewEnvironmentName
}
