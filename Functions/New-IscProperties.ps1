Function New-IscProperties {
    <#
.Synopsis
Takes Integration Services Catalog Properties and loads them into a hash table
.Description
Internal function
Used to return a hash table of the properties instead of using json objects
As it's a customObject anything could be loaded really.
.Parameter JsonObject
After we have called Import-Json we load values into a hash table for the "IntegrationServicesCatalog" properties
Used pretty much everywhere!
.Example
$ssisProperties = New-IscProperties -jsonObject $ssisJson
#>
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [PSCustomObject] $jsonObject
    )
    try {
        $isc = @{"ssisFolderName"          = $jsonObject.integrationServicesCatalog.ssisFolderName
            ; "ssisProjectName"            = $jsonObject.integrationServicesCatalog.ssisProjectName
            ; "ssisEnvironmentName"        = $jsonObject.integrationServicesCatalog.ssisEnvironmentName
            ; "ssisEnvironmentDescription" = $jsonObject.integrationServicesCatalog.ssisEnvironmentDescription
        }
        return $isc
    }
    catch {
        throw $_.Exception.InnerException.ToString()
    }
}