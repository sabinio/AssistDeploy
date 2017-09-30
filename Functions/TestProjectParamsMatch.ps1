function Test-ProjectParamsMatch {
    <#
.Synopsis
Import the integration services catalog publish json file
.Description
Internal function used to import the json file that stores the integration services catalog properties and variables.
.Parameter jsonObject
Json object.
.Parameter ispacPath
File path of ispac file.
.Example
Test-ProjectParamsMatch -jsonObject "C:\Users\SQLTraining\Documents\iscPublish.json" -ispacPath "C:\Users\SQLTraining\Documents\iscPublish.ispac"
#>
    param
    (
        [Parameter(Position = 0, mandatory = $true)]
        [PSCustomObject] $jsonObject,
        [Parameter(Position = 1, mandatory = $true)]
        [String] $ispacPath
    )
    $ispacFilePath = Split-Path $ispacPath -Parent
    $ispacFileName = Split-Path $ispacPath -Leaf
    $ispacFilePath = Join-Path $ispacFilePath -ChildPath "unpack"
    if (Test-Path $ispacFilePath) {
        Remove-Item -r $ispacFilePath
    }
    New-Item $ispacFilePath -ItemType Directory
    $jsonArray = $jsonObject.SsisEnvironmentVariable.Parameter | Where-Object {$_.ParameterType -eq "project"}
    if ($jsonArray.Count -gt 1) {
        [System.Collections.ArrayList] $jsonArrayParameterName = $JsonArray.ParameterName
    }
    else {
        $jsonArrayParameterName = $JsonArray.ParameterName
    }
    Remove-Variable -Name jsonArray
    Copy-Item $thisIspacToDeploy -Destination $ispacFilePath
    Rename-Item -Path (Join-Path $ispacFilePath -ChildPath $ispacFileName) -NewName "$ispacFileName.zip"
    $zipFile = Join-Path $ispacFilePath -ChildPath "$ispacFileName.zip"
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace($zipFile)
    foreach ($item in $zip.items()) {
        $shell.Namespace($ispacFilePath).copyhere($item)
    }
    $projectParamsFile = Join-Path $ispacFilePath -ChildPath "Project.params"
    [xml]$projectParams = Get-Content $projectParamsFile
    foreach ($projectParam in $projectParams.Parameters.Parameter) {
        if ($jsonArrayParameterName -contains $projectParam.Name) {
            Write-Verbose ("Project parameter $($projectParam.Name) in json exists in json. " -f $varName) -Verbose
            [string]$varType = $jsonArrayParameterName.GetType() 
            if ($varType -ne "string") {
                $jsonArrayParameterName.Remove($projectParam.Name)
            }
            else {
                Clear-Variable -Name jsonArrayParameterName
            }
        }
        else {
            [string]$missingVariables += $projectParam.Name + ' '
        }
    }
    if ($missingVariables.Count -gt 0) {
        throw ('The following project params are not present in the json file: {0}' -f ($missingVariables -join " `n"))
    }
    if ($jsonArrayParameterName.Count -gt 0) {
        Write-Warning ('The following json parameters and corresponding environment variables are no longer required to be in the json file: {0}' -f ($jsonArrayParameterName -join " `n"))
    }
}