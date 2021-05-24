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
        [string]$missingSev=$null;
        if (!$envVar.VariableName)
        {$missingSev += "VariableName "}
        if (!$envVar.DataType)
        {$missingSev += "DataType "}
        if ("$($envVar.isSensitive)" -eq "" )                     
        {$missingSev += "isSensitive "}
        if ($missingSev) {
            $err += ("`n" + 'Values are not specified for the following names in a SsisEnvironmentVariable object in the json file: {0}' -f ($missingSev -join " `n"))
        }
        [String]$variableNameType = $envVar.VariableName.GetType()  
        Write-Verbose "VariableName type: $variableNameType" -Verbose
        if ($variableNameType -ne "string") {
            $Name = "VariableName {0}" -f $envVar.VariableName
            $varType = $variableNameType + ", should be string."
            $badType | Add-Member -MemberType NoteProperty -Name $Name -Value $varType           
        }

        [String]$dataTypeType = $envVar.DataType.GetType()    
        Write-Verbose "DataType type: $dataTypeType" -Verbose      
        if ($dataTypeType -ne "string") {
            $Name = "VariableName {0} DataType {1}" -f $envVar.VariableName, $envVar.DataType
            $varType = $dataTypeType + ", should be string."
            $badType | Add-Member -MemberType NoteProperty -Name $Name -Value $varType
        } 

        [string]$isSensitiveType = $envVar.IsSensitive.GetType()
        Write-Verbose "IsSensitive type: $isSensitiveType" -Verbose 
        if ($isSensitiveType -ne "bool") {
            $Name = "VariableName {0} IsSensitive {1}" -f $envVar.VariableName, $envVar.IsSensitive
            $varType = $isSensitiveType + ", should be boolean."
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

            [string]$parameterNameType = $param.ParameterName.GetType()
            Write-Verbose "ParameterName type: $parameterNameType" -Verbose           
            if ($parameterNameType -ne "string") {
                $Name = "variable {0} ParameterName {1}" -f $envVar.VariableName, $param.ParameterName
                $varType = $parameterNameType + ", should be string."
                $badType | Add-Member -MemberType NoteProperty -Name $Name-Value $varType
            }

            [string]$parameterTypeType = $param.parameterType.GetType()
            Write-Verbose "ParameterType type: $parameterTypeType" -Verbose 
            if ($parameterTypeType -ne "string") {
                $Name = "variable {0}, ParameterName {1} ParameterType {2}" -f $envVar.VariableName, $param.ParameterName, $param.ParameterType
                $varType = $parameterTypeType + ", should be string."
                $badType | Add-Member -MemberType NoteProperty -Name $param.parameterType -Value $varType
            }
            if ($param.parameterType -eq "Package") {
                [string]$objectNameType = $param.ObjectName.GetType()
                Write-Verbose "ObjectName type: $objectNameType" -Verbose 
                if ($objectNameType -ne "string") {
                    $Name = "variable {0}, ParameterName {1} objectName {2}" -f $envVar.VariableName, $param.ParameterName, $param.ParameterType
                    $varType = $objectNameType + ", should be string."
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