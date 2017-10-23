function Import-Json {
    <#
.Synopsis
Import the integration services catalog publish json file
.Description
Internal function used to import the json file that stores the integration services catalog properties and variables.
.Parameter jsonPath
File path of json file.
.Parameter ispacPath
File path of ispac file.
.Parameter localVariables
Switch to determine whether we need to validate that variables with the name of the variableName exists or not in current session.
.Example
$ssisJson = Import-Json -jsonPath "C:\Users\SQLTraining\Documents\iscPublish.json" -ispacPath "C:\Users\SQLTraining\Documents\iscPublish.ispac"
#>
    param
    (
        [Parameter(Position = 0, mandatory = $true)]
        [String] $jsonPath,
        [Parameter(Position = 1, mandatory = $true)]
        [String] $ispacPath,
        [Parameter(Position = 2, mandatory = $false)]
        [Switch] $localVariables
    )
    try {
        Write-Verbose "Importing json..." -Verbose
        $json = Get-Content -Raw -Path $jsonPath -Encoding UTF8 | ConvertFrom-Json
        $jsonTested = Test-Json -jsonToTest $json
    }
    catch {
        throw $_.Exception
    }
    if (!$localVariables) {
        try {
            Write-Verbose "Testing the PowerShell variables exist to update values in json file... " -Verbose
            Test-VariablesForPublishProfile -jsonPsCustomObject $jsonTested
        }
        catch {
            throw $_.Exception
        }
    }
    else{
        try {
            Write-Verbose "Testing the environment variables in json file have a value... " -Verbose
            Test-VariablesForPublishProfile -jsonPsCustomObject $jsonTested -localVariables
        }
        catch {
            throw $_.Exception
        }
    }
    try {
        Write-Verbose "Testing project params in project.params match the project params in the json file..." -Verbose
        Test-ProjectParamsMatch -jsonObject $jsonTested -ispacPath $ispacPath
    }
    catch {
        throw $_.Exception
    }
    return $jsonTested
}