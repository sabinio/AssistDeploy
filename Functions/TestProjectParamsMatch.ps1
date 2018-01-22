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
    try {
        $ispacFilePath = Split-Path $ispacPath -Parent
        $ispacFileName = Split-Path $ispacPath -Leaf
        $unpacFilepath = Join-Path $ispacFilePath -ChildPath "unpack"
        if (Test-Path $unpacFilepath) {
            Write-Verbose "Removing $unpacFilepath..." -Verbose
            Remove-Item -r $unpacFilepath
        }
        try {
            Write-Verbose "Creating $unpacFilepath" -Verbose
            New-Item $unpacFilepath -ItemType "Directory" -Force
        }
        catch {
            throw $_.Exception
        }
        $ispacFileNameNoExtension = [System.Io.Path]::GetFileNameWithoutExtension($ispacPath)
        if ($ispacFileNameNoExtension -ne $jsonObject.IntegrationServicesCatalog.ssisProjectname)
        {
            Write-Error "Ispac File and ($ispacFileNameNoExtension) and project name in json file ($($jsonObject.IntegrationServicesCatalog.ssisProjectname)) do not match. Mismatch will cause deployment to fail..."
            Throw
        }
        $jsonArray = $jsonObject.SsisEnvironmentVariable.Parameter | Where-Object {$_.ParameterType -eq "project"}
        if ($jsonArray.Count -gt 1) {
            [System.Collections.ArrayList] $jsonArrayParameterName = $JsonArray.ParameterName
        }
        else {
            $jsonArrayParameterName = $JsonArray.ParameterName
        }
        Remove-Variable -Name jsonArray
        try {
            Write-Verbose "Copying $ispacFileName and unpacking..."
            Copy-Item $ispacPath -Destination $unpacFilepath
            Rename-Item -Path (Join-Path $unpacFilepath -ChildPath $ispacFileName) -NewName "$ispacFileName.zip"
            $zipFile = Join-Path $unpacFilepath -ChildPath "$ispacFileName.zip"
            $shell = new-object -com shell.application
            $zip = $shell.NameSpace($zipFile)
            foreach ($item in $zip.items()) {
                $shell.Namespace($unpacFilepath).copyhere($item)
            }
        }
        catch {
            Write-Verbose "Something went wrong in unpacking ispac." -Verbose
            Write-Verbose $_.Exception
            throw
        }
        $projectParamsFile = Join-Path $unpacFilepath -ChildPath "Project.params"
        if ($projectParamsFile.Length -eq 0) {
            Write-Verbose "Project params file not found" -Verbose
            Throw 1
        }
        Write-Verbose "project params file found - $projectParamsFile" -Verbose
        [xml]$projectParams = Get-Content $projectParamsFile
        foreach ($projectParam in $projectParams.Parameters.Parameter) {
            if ($jsonArrayParameterName -contains $projectParam.Name) {
                Write-Verbose ("Project parameter $($projectParam.Name) in project.params file  exists in json. " -f $varName) -Verbose
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
    catch {
        $_.Exception | Out-Null
    }
    finally {
        Write-Verbose "Removing the unpacked folder."
        Remove-Item $unpacFilepath -Force -Recurse
    }
}