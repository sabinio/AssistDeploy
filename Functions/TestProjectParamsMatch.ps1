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
    $jsonParameterNameArray = $myJsonPublishProfile.SsisEnvironmentVariable.Parameter | Where-Object {$_.ParameterType -eq "project"}
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
        if ($jsonParameterNameArray.ParameterName -contains $projectParam.Name) {
            Write-Verbose ("Project parameter $($projectParam.Name) in json matches project parameter $($jsonParameterNameArray.ParameterName) in ispac. " -f $varName) -Verbose
        }
        else {
            [string]$missingVariables += $projectParam.Name + ' '
        }
    }
    if ($missingVariables.Count -gt 0) {
        throw ('The following project params are not defined in the session (but are defined in the json file): {0}' -f ($missingVariables -join " `n"))
    }

    if ($projectParams.Parameters.Parameter.Count -gt $jsonParameterNameArray.Count) {
        throw ("The count between project parameters in the ispac ($($projectParams.Parameters.Parameter.Count)) are greater than what is in the json file ($($jsonParameterNameArray.Count)). `n This implies that the json file is missing a parameter. Please review.")
    }

    if ($projectParams.Parameters.Parameter.Count -lt $jsonParameterNameArray.Count) {
        Write-warning ("The count between project parameters in the ispac ($($projectParams.Parameters.Parameter.Count)) are less than what is in the json file ($($jsonParameterNameArray.Count)). `n This implies that the json file has too many project parameters. This will not cause a faile deployment, but is not a good thing. Please review.")
    }
}