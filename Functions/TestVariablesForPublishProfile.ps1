function Test-VariablesForPublishProfile {
    <#
    .SYNOPSIS
    Unimplemented check for variables, as added straight into Publish-SsisVariables. Kept as may be required in the future.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        $ssisPublishFilePath
    )
    $missingVariables = @()
    $ssisJson = Import-Json -path $ssisPublishFilePath
    $keys = $($ssisJson.ssisEnvironmentVariable)
    foreach ($var in $keys) {
        $varName = $var.VariableName
        if ((Test-Path variable:$varName) -eq $false) {
            [string]$missingVariables += $var.VariableName
        }
        if ($missingVariables.Count -gt 0) {
            throw ('The following ssisEnvironmentVariable variables are not defined in the session (but are defined in the isc_publish profile): {0}' -f ($missingVariables -join " `n"))
        }
    }
}