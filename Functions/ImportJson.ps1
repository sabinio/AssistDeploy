function Import-Json {
    <#
.Synopsis
Import the integration services catalog publish json file
.Description
Internal function used to import the json file that stores the integration services catalog properties and variables.
.Parameter path
File path of json file.
.Example
$ssisJson = Import-Json -path "C:\Users\SQLTraining\Documents\iscPublish.json"
#>
    param
    (
        [Parameter(Position = 0, mandatory = $true)]
        [String] $path
    )
    try {
        $json = Get-Content -Raw -Path $path -Encoding UTF8 | ConvertFrom-Json
        return $json
    }
    catch {
        throw $_.Exception.InnerException.ToString()
    }
}
