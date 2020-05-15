function Test-VariablesForPublishProfile {
    <#
    .Synopsis
    Validates variables used in the publish profile
    .Description
    Validates variables used in the publish profile.  If -localVariables is false, this function tries to find a variable - either a true powershell variable (e.g. $Foo),
    or an environment variable (e.g. $Env:Foo) for each property found in $jsonPsCustomObject.ssisEnvironmentVariable.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, mandatory = $true)]
        [PSCustomObject] $jsonPsCustomObject,
        [Parameter(Position = 0, mandatory = $false)]
        [Switch] $localVariables,
        [Parameter(Position = 2, mandatory = $false)]
        [ValidateSet('Env','PS')]
        [string] $variableType = 'PS'
    )
    $missingVariables = @()
    $ssisJson = $jsonPsCustomObject
    if (!$localVariables) {
        $keys = $($ssisJson.ssisEnvironmentVariable)
        foreach ($var in $keys) {
            $varName = $var.VariableName
            if (Test-Variable -variableName $varName -variableType $variableType) {
                Write-Verbose ('{0} Variable {1} exists in session. ' -f $variableType, $varName) -Verbose
            }
            else {
                [string]$missingVariables += $var.VariableName + ' '
            }
        }
        if ($missingVariables.Count -gt 0) {
            throw ('The following ssisEnvironmentVariable variables are not defined in the session as {0} (but are defined in the json file): {1}' -f $variableType,  ($missingVariables -join " `n"))
        }
    }
    else{
        Write-Verbose "Validating that each environment variable named in json file has a value." -Verbose
        $keys = $($ssisJson.ssisEnvironmentVariable)
        foreach ($var in $keys)
        {   
            $varValue = $var.Value
            if ($varValue.Length -eq 0)
            {   
                $msg = "$($var.VariableName) does not have a value. Cannot use switch -localVariables where an environment variable does nto have a value. "
                Throw $msg
            }
        }
    }
}