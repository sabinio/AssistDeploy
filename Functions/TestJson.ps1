function Test-Json {
    <#
.Synopsis
Validate json is valid
.Description
Checks that the keys for the json are as expected.
.Parameter jsonToTest
json object.
.Example
$ssisJson = Import-Json -path "C:\Users\SQLTraining\Documents\iscPublish.json"
#>
    [CmdletBinding]
    param
    (
        [Parameter(Position = 0, mandatory = $true)]
        [PSCustomObject] 
        $jsonToTest
    )
    $err = $null
    try {
        
        if (!$jsonToTest.integrationServicesCatalog.ssisFolderName)
        {$missingIsc += "ssisFolderName "}
        
        if (!$jsonToTest.integrationServicesCatalog.ssisEnvironmentName)
        {$missingIsc += "ssisEnvironmentName "}
        
        if (!$jsonToTest.integrationServicesCatalog.ssisProjectName)
        {$missingIsc += "ssisProjectName "}
        
        if (!$jsonToTest.integrationServicesCatalog.ssisEnvironmentDescription)
        {$missingIsc += "ssisEnvironmentDescription "}
    }
    catch {
        throw $_.Exception
    }
    if ($missingIsc) {
        $err = ('Values are not specified for the following names in the IntegrationServicesCatalog object in the json file: {0}' -f ($missingIsc -join " `n"))
    }
    $badType = New-Object -TypeName PSObject
    foreach ($envVar in $jsonToTest.SsisEnvironmentVariable) {
        if (!$envVar.VariableName)
        {$missingSev += "VariableName "}
        if (!$envVar.DataType)
        {$missingSev += "DataType "}
        if (([String]$isSensitive = $envVar.isSensitive) -eq "" )
        {$missingSev += "isSensitive "}
        if ($missingSev) {
            $err += ("`n" + 'Values are not specified for the following names in a SsisEnvironmentVariable object in the json file: {0}' -f ($missingSev -join " `n"))
        }
        if (([string]$varType = $envVar.VariableName.GetType()) -ne "string") {
            $Name = "VariableName {0}" -f $envVar.VariableName
            $varType += ", should be string."
            $badType | Add-Member -MemberType NoteProperty -Name $Name -Value $varType
        }
        if (([string]$varType = $envVar.DataType.GetType()) -ne "string") {
            $Name = "VariableName {0} DataType {1}" -f $envVar.VariableName, $envVar.DataType
            $varType += ", should be string."
            $badType | Add-Member -MemberType NoteProperty -Name $Name -Value $varType
        } 
        if (([string]$varType = $envVar.IsSensitive.GetType()) -ne "bool") {
            $Name = "VariableName {0} IsSensitive {1}" -f $envVar.VariableName, $envVar.IsSensitive
            $varType += ", should be boolean."
            $badType | Add-Member -MemberType NoteProperty -Name $Name -Value $varType
        } 
        foreach ($param in $envVar.parameter) {
            if (!$param.parameterType)
            {$missingParam += "parameterType "}
            if (!$param.parameterName)
            {$missingParam += "parameterName "}
            if ($param.parameterType -eq "Package") {
                if (!$param.ObjectName)
                {$missingParam += "ObjectName "}
            }
            if ($missingParam) {
                $err += ("`n" + 'Values are not specified for the following names in a parameter object in the json file: ssisEnvironmentVariable{0}, parameter' -f ($envVar.Variablename, $missingParam -join " `n"))
            }
            if (([string]$varType = $param.ParameterName.GetType()) -ne "string") {
                $Name = "variable {0} ParameterName {1}" -f $envVar.VariableName, $param.ParameterName
                $varType += ", should be string."
                $badType | Add-Member -MemberType NoteProperty -Name $Name-Value $varType
            }
            if (([string]$varType = $param.parameterType.GetType()) -ne "string") {
                $Name = "variable {0}, ParameterName {1} ParameterType {2}" -f $envVar.VariableName, $param.ParameterName, $param.ParameterType
                $varType += ", should be string."
                $badType | Add-Member -MemberType NoteProperty -Name $param.parameterType -Value $varType
            }
            if ($param.parameterType -eq "Package") {
                if (([string]$varType = $param.ObjectName.GetType()) -ne "string") {
                    $Name = "variable {0}, ParameterName {1} objectName {2}" -f $envVar.VariableName, $param.ParameterName, $param.ParameterType
                    $varType += ", should be string."
                    $badType | Add-Member -MemberType NoteProperty -Name $param.parameterType -Value $varType
                }
            }
        }
    }
    if ($badType.PSObject.Properties.Count -gt 0) {
        $msg = "The following values have wrong typing: "
        $badType.PSObject.Properties | ForEach-Object {
            $msg += "`n" + $_.Name + " is type " + $_.Value 
        }
        $err += "`n" + $msg
    }
    if ($err.Length -gt 0) {
        throw $err
    }
    return $jsonToTest
}
