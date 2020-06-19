function Add-IscProperty {
    <#
.Synopsis
Add a property to the hash table
.Description
Internal function
Add a value to the hash table for use further in the functions
.Parameter iscProperties
The hash table that we are adding a property to.
.Parameter ssisPropertyName
The name of the property - we may wish to add a new envrionment name to the list of properties we are passing around
.Parameter ssisProperyValue
The value ofthe given property ie the name of the new environment name
.Example
$ssisProperties = Add-IscProperty -iscProperties $ssisProperties -ssisPropertyName "ssisNewEnvironmentName" -ssisPropertyValue $ssisNewEnvironmentName
.Notes
For working example, see "EditSSISEnvironmentName.ps1"
Generally used in a rollback scenario, but seeing as we are not supporting this scenario currently it is not in use in any of the tests.
#>
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [hashtable] $iscProperties,
        [Parameter(Position = 1, mandatory = $true)]
        [string] $ssisPropertyName,
        [Parameter(Position = 2, mandatory = $true)]
        [string] $ssisPropertyValue)

    try {
        Write-Verbose "Adding $ssisPropertyName with value $ssisPropertyValue to iscProperties hashtable..." -Verbose
        $iscProperties.Add("$ssisPropertyName", "$ssisPropertyValue")
    }
    catch {
        throw $_.Exception
    }
    return $iscProperties
}
