
Function Publish-SsisEnvironment {
    <#
.Synopsis
If it doesn't exist, publish environment
.Description
Before we can publish variables and environment references, we will need to create an environment
uses publish json file to get values required
Non-mandatory params here can be used to overwrite the values stored in the publish json file passed in
.Parameter jsonPsCustomObject
Tested json object loaded from Import-Json
.Parameter sqlConnection
The SQL Connection to SSISDB
.Parameter ssisFolderName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisEnvironmentName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisEnvironmentDescription
Optional parameter. We may wish to override the value of what is in the json file.
.Example
1)
Publish-SsisEnvironment -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
2)
$envName "bob"
Publish-SsisEnvironment -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -ssisEnvironmentName $envName
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
        [String] $ssisEnvironmentDescription)

    $ssisJson = $jsonPsCustomObject
    $ssisProperties = New-IscProperties -jsonObject $ssisJson
    if ($ssisFolderName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisFolderName $ssisFolderName
    }
    if ($ssisEnvironmentName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisEnvironmentName $ssisEnvironmentName
    }
    if ($ssisEnvironmentDescription) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisEnvironmentDescription $ssisEnvironmentDescription
    }
    $sqlPublishSsisEnvironment = "
IF NOT EXISTS (
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
EXEC CATALOG.create_environment 
@folder_name = @1
,@environment_name = @0
,@environment_description = @2
END"
    try {
        $msg = "Checking if environment " + $ssisProperties.ssisEnvironmentName + " exists and if not will create..."
        Write-Verbose $msg -Verbose
        $sqlCmdPublishEnvironment = New-Object System.Data.SqlClient.SqlCommand($sqlPublishSsisEnvironment, $sqlConnection)
        $sqlCmdPublishEnvironment.Parameters.AddWithValue("@0", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCmdPublishEnvironment.Parameters.AddWithValue("@1", $ssisProperties.ssisFolderName) | Out-Null
        $sqlCmdPublishEnvironment.Parameters.AddWithValue("@2", $ssisProperties.ssisEnvironmentDescription) | Out-Null
        $sqlCmdPublishEnvironment.ExecuteNonQuery() | Out-Null
        Write-Verbose "SQL Script Succeeded. Checking environment exists..." -Verbose
    }
    catch {
        $msg = "Creating environment " + $ssisProperties.ssisEnvironmentName + " failed."
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
        $sqlCmdVerifyEnvironment = New-Object System.Data.SqlClient.SqlCommand($sqlCheckSsisEnvironmentExists, $sqlConnection)
        $sqlCmdVerifyEnvironment.Parameters.AddWithValue("@0", $ssisProperties.ssisEnvironmentName) | Out-Null
        $sqlCmdVerifyEnvironment.Parameters.AddWithValue("@1", $ssisProperties.ssisFolderName) | Out-Null
        $checkSsisEnvironmentExists = [String]$sqlCmdVerifyEnvironment.ExecuteScalar()
        if ($checkSsisEnvironmentExists -eq "exists") {
            $msg = "Environment " + $ssisProperties.ssisEnvironmentName + " exists."
            Write-Verbose $msg -Verbose
        }
        else {
            $msg = "Environment " + $ssisProperties.ssisEnvironmentName + " does not exist."
            Write-Verbose $msg -Verbose
            Throw;
        }
    }
    catch {
        Write-Error $_.Exception
    }
}
