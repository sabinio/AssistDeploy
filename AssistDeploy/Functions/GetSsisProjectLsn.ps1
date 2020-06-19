
Function Get-SsisProjectLsn {
    <#
.Synopsis
Get latest project lsn. This is effectively the version number of the project.
.Description
useful for when we may need to rollback, this is the latest lsn for a given project.
.Parameter jsonPsCustomObject
Tested json object loaded from Import-Json
.Parameter sqlConnection 
The SQL Connection to SSISDB
.Parameter ssisFolderName
Optional parameter. We may wish to override the value of what is in the json file.
.Example
$ssisLatestProjectLsn = Get-SsisProjectLsn -ssisPublishFilePath $thisSsisPublishFilePath -sqlConnection $ssisdb
.Notes
Used in rollback process, but seeing as we're not currently using that process this is not currently in use.
#>

    [CmdletBinding()]
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [PSCustomObject] $jsonPsCustomObject,
        [Parameter(Position = 1, mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] $sqlConnection,
        [Parameter(Position = 2, mandatory = $false)]
        [String] $ssisFolderName)

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
    $sqlGetLsn = "
SELECT MAX (project.object_version_lsn)
FROM CATALOG.projects project
WHERE project.NAME = @0
AND project.folder_id = (
SELECT folder.folder_id
FROM CATALOG.folders folder
WHERE NAME = @1
)
"
    $sqlCommandGetLsn = New-Object System.Data.SqlClient.SqlCommand($sqlGetLsn, $sqlConnection)
    $sqlCommandGetLsn.Parameters.Add("@0", $ssisProperties.ssisProjectName) | Out-Null
    $sqlCommandGetLsn.Parameters.Add("@1", $ssisProperties.ssisFolderName) | Out-Null
    $ssisProjectCurrentLsn = $sqlCommandGetLsn.ExecuteScalar()
    $ssisProjectCurrentLsnType = $ssisProjectCurrentLsn.GetType()
    if ($ssisProjectCurrentLsnType.name -ne "Int64") {
        Write-Verbose "There is no objectLsn to rename environment to." -Verbose
        $ssisProjectCurrentLsn = $null
    }
    Return $ssisProjectCurrentLsn
}
