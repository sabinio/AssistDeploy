function Test-VariablesForPublishProfile {
    <#
    .SYNOPSIS
    Unimplemented check for variables, as added straight into Publish-SsisVariables. Kept as may be required in the future.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, mandatory = $true)]
        [PSCustomObject] $jsonPsCustomObject
    )
    $missingVariables = @()
    $ssisJson = $jsonPsCustomObject
    if (!$localVariables) {
        $keys = $($ssisJson.ssisEnvironmentVariable)
        foreach ($var in $keys) {
            $varName = $var.VariableName
            if (Test-Path variable:$varName) {
                Write-Verbose ('Variable {0} exists in session. ' -f $varName) -Verbose
            }
            else {
                [string]$missingVariables += $var.VariableName + ' '
            }
        }
        if ($missingVariables.Count -gt 0) {
            throw ('The following ssisEnvironmentVariable variables are not defined in the session (but are defined in the json file): {0}' -f ($missingVariables -join " `n"))
        }
    }
}