function Set-IscProperty {
    <#
.Synopsis
Overwrite the value that is imported
.Description
Internal function
All properties are inherited from the publish json file,
but there may come a time when we need to overwrite it (when testing)
or through Octopus step templates (using UI in fields)
This is called internally by other functions when
parameter is added to callingsomething like "publish-ssisFolder"
.Parameter iscProperties
The hash table that we are altering a property of.
.Parameter newSsisFolderName
Optional parameter. Updated value of parameter.
.Parameter newSsisProjectName
Optional parameter. Updated value of parameter.
.Parameter newSsisEnvironmentName
Optional parameter. Updated value of parameter.
.Parameter newSsisEnvironmentDescription
Optional parameter. Updated value of parameter.
.Example
if ($ssisFolderName) {
$ssisProperties = Set-IscProperty -iscProperties $ssisProperties -newSsisFolderName $ssisFolderName
}
#>
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [hashtable] $iscProperties,
        [Parameter(mandatory = $false)]
        [string] $newSsisFolderName,
        [Parameter(mandatory = $false)]
        [string] $newSsisProjectName,
        [Parameter(mandatory = $false)]
        [string] $newSsisEnvironmentName,
        [Parameter(mandatory = $false)]
        [string] $newSsisEnvironmentDescription
    )
    If ($newSsisFolderName) {
        Write-Verbose "Value of ssis folder name being overwritten with $newSsisFolderName" -Verbose
        $iscProperties.Set_Item("ssisFolderName", $newSsisFolderName)
    }
    if ($newSsisProjectName) {
        Write-Verbose "Value of ssis project name being overwritten with $newSsisProjectName" -Verbose
        $iscProperties.Set_Item("ssisProjectName", $newSsisProjectName)
    }
    if ($newSsisEnvironmentName) {
        Write-Verbose "Value of ssis environment name being overwritten with$newSsisEnvironmentName" -Verbose
        $iscProperties.Set_Item("ssisEnvironmentName", $newSsisEnvironmentName)
    }
    if ($newSsisEnvironmentDescription) {
        Write-Verbose "Value of ssis environment description being overwritten with$newSsisEnvironmentDescription" -Verbose
        $iscProperties.Set_Item("ssisEnvironmentDescription", $newSsisEnvironmentDescription)
    }
    return $iscProperties
}