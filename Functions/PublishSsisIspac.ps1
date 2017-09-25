Function Publish-SsisIspac {
    <#
.Synopsis
Publish an ispac to a project folder.
.Description
Publish an ispac and check that it was deployed.
$ispacToDeploy is a file path.
We convert into bits and pass in.
Non-mandatory params here can be used to overwrite the values stored in the publish json file passed in
.Parameter ssisPublishFilePath
Filepath of json file containing the project parameters (eg Project Folder Name, Project Environment Name)
.Parameter sqlConnection
The SQL Connection to SSISDB
.Parameter ispacToDeploy
File path to ispac we want to deploy. Convert to byte object then execute as VARBINARY
.Parameter ssisFolderName
Optional parameter. We may wish to override the value of what is in the json file.
.Parameter ssisProjectName
Optional parameter. We may wish to override the value of what is in the json file.
.Example
1)
Publish-SsisIspac -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -ispacToDeploy $thisIspacToDeploy
2)
Publish-SsisIspac -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -ispacToDeploy $thisIspacToDeploy -ssisFolderName "newFolder"
#>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [string] $ssisPublishFilePath,
        [Parameter(Position = 1, mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] $sqlConnection,
        [Parameter(Position = 2, mandatory = $true)]
        [string] $ispacToDeploy,
        [Parameter(Position = 3, mandatory = $false)]
        [String] $ssisFolderName,
        [Parameter(Position = 4, mandatory = $false)]
        [string] $ssisProjectName)
    $ssisJson = Import-Json -path $ssisPublishFilePath
    $ssisProperties = New-IscProperties -jsonObject $ssisJson
    if ($ssisFolderName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisFolderName $ssisFolderName
    }
    if ($ssisProjectName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisProjectName $ssisProjectName
    }
    [byte[]] $ispacAsBytes = [System.IO.File]::ReadAllBytes($ispacToDeploy)

    $sqlPublishSsisIspac = "
DECLARE @ispac_file VARBINARY(MAX) = @0
DECLARE @operation_id BIGINT
DECLARE @project_binary VARBINARY(MAX)
SET @project_binary = @ispac_file
EXEC CATALOG.deploy_project @folder_name = @1
,@project_name = @2
,@project_stream = @project_binary
,@operation_id = @operation_id OUTPUT
"
    try {
        $msg = "Publishing project " + $ssisProperties.ssisProjectName
        Write-Verbose $msg -Verbose
        $sqlCmdPubIspac = New-Object System.Data.SqlClient.SqlCommand($sqlPublishSsisIspac, $sqlConnection)
        $sqlCmdPubIspac.Parameters.AddWithValue("@0", $ispacAsBytes) | Out-Null
        $sqlCmdPubIspac.Parameters.AddWithValue("@1", $ssisProperties.ssisFolderName) | Out-Null
        $sqlCmdPubIspac.Parameters.AddWithValue("@2", $ssisProperties.ssisProjectName) | Out-Null
        $ispacOperationId = $sqlCmdPubIspac.ExecuteNonQuery()
        $msg = "SQL Script Succeeded. Checking project exists..."
        Write-Verbose $msg -Verbose
    }
    catch {
        $msg = "Publishing " + $ssisProperties.ssisProjectName + " ispac failed."
        Write-Verbose $msg -Verbose
        $pattern = "(?<=operation_messages view for the operation identifier ').+?[0-9]"
        $ispacOperationId = [regex]::match($_.Exception, $pattern).Value
        Write-Error $_.Exception
    }
    finally {
        if ($ispacOperationId -gt 0) {
            $sqlGetOperationIdMessage = "
SELECT om.message
FROM CATALOG.operation_messages om
WHERE om.operation_id = @0           
"
            $msg = "Project deployment has failed. This is the output from querying operation_messages view using operation_identifier " +$ispacOperationId
            Write-Verbose $msg -Verbose
            $sqlCommandMessage = New-Object System.Data.SqlClient.SqlCommand($sqlGetOperationIdMessage, $sqlConnection)
            $sqlCommandMessage.Parameters.AddWithValue("@0", $ispacOperationId) | Out-Null
            $sqlOperationMessage = [String]$sqlCommandMessage.ExecuteScalar()
            Write-Verbose $sqlOperationMessage -Verbose
        }
    }
    try {
        $sqlCheckSsisIspacExists = "
SELECT 'exists'
FROM CATALOG.projects project
WHERE project.folder_id = (
SELECT folder.folder_id
FROM CATALOG.folders folder
WHERE folder.NAME = @0
)
AND project.NAME = @1
"
        $sqlCmdVerify = New-Object System.Data.SqlClient.SqlCommand($sqlCheckSsisIspacExists, $sqlConnection)
        $sqlCmdVerify.Parameters.AddWithValue("@0", $ssisProperties.ssisFolderName) | Out-Null
        $sqlCmdVerify.Parameters.AddWithValue("@1", $ssisProperties.ssisProjectName) | Out-Null
        $checkSsisIspacExists = [String]$sqlCmdVerify.ExecuteScalar()
        if ($checkSsisIspacExists -eq "exists") {
            $msg = "Project " + $ssisProperties.ssisProjectName + " exists."
            Write-Verbose $msg -Verbose
        }
        else {
            Write-Verbose "Project does not exist." -Verbose
            Throw;
        }
    }
    catch {
        Write-Error $_.Exception
    }
}