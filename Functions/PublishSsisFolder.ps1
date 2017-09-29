Function Publish-SsisFolder {
    <#
.Synopsis
Create a catalog folder
.Description
If not exists, create a catalog folder
We will then be ableto deploy projects and environments
Non-mandatory params here can be used to overwrite the values stored in the publish json file passed in
.Parameter ssisPublishFilePath
Filepath of json file containing the project parameters (eg Project Folder Name, Project Environment Name)
.Parameter sqlConnection
The SQL Connection to SSISDB
.Parameter ssisFolderName
Optional parameter. We may wish to override the value of what is in the json file.
.Example
Publish-SsisFolder -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
Publish-SsisFolder -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb -ssisFolderName "bob"
#>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [string] $ssisPublishFilePath,
        [Parameter(Position = 1, mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] $sqlConnection,
        [Parameter(Position = 2, mandatory = $false)]
        [String] $ssisFolderName)

    Measure-Command {$ssisJson = Import-Json -path $ssisPublishFilePath}
    $ssisProperties = New-IscProperties -jsonObject $ssisJson
    if ($ssisFolderName) {
        $ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisFolderName $ssisFolderName
    }
    $sqlPublishSsisFolder = "
DECLARE @folder_id BIGINT
IF NOT EXISTS (
SELECT 1
FROM CATALOG.folders folder
WHERE folder.NAME = @0
)
BEGIN
EXEC CATALOG.create_folder @0
,@folder_id = @folder_id OUTPUT
END"
    try {
        $msg = "Checking if folder "+$ssisProperties.ssisFolderName+" exists and if not will create..."
        Write-Verbose $msg -Verbose
        $sqlCommandPublishFolder = New-Object System.Data.SqlClient.SqlCommand($sqlPublishSsisFolder, $sqlConnection)
        $sqlCommandPublishFolder.Parameters.AddWithValue("@0", $ssisProperties.ssisFolderName) | Out-Null
        $sqlCommandPublishFolder.ExecuteNonQuery() | Out-Null
        Write-Verbose "SQL Script Succeeded. Checking folder exists..." -Verbose
    }

    catch {
        $msg = "Creating folder "+$ssisProperties.ssisFolderName+" failed"
        Write-Error $_.Exception
    }
    try {
        $sqlCheckSsisFolderExists = "
SELECT 'exists'
FROM CATALOG.folders folder
WHERE folder.NAME = @0
"
        $sqlCommandVerifyFolder = New-Object System.Data.SqlClient.SqlCommand($sqlCheckSsisFolderExists, $sqlConnection)
        $sqlCommandVerifyFolder.Parameters.AddWithValue("@0", $ssisProperties.ssisFolderName) | Out-Null
        $checkSsisFolderExists = [String]$sqlCommandVerifyFolder.ExecuteScalar()
        if ($checkSsisFolderExists -eq "exists") {
            $msg = "Folder "+$ssisProperties.ssisFolderName+" exists."
            Write-Verbose $msg -Verbose
        }
        else {
            $msg = "Folder "+$ssisProperties.ssisFolderName+" does not exist."
            Write-Verbose $msg -Verbose
            Throw;
        }
    }
    catch {
        Write-Error $_.Exception
    }
}
