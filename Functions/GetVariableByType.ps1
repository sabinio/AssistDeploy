function Get-VariableByType {
    <#
    .Synopsis
    Gets a variable value
    .Description
    Gets a variable value, which may be either a true powershell variable (e.g $Foo), or an environment variable (e.g $Env:Foo) 
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, mandatory = $true)]
        [string] $variableName,
        [Parameter(Position = 1, mandatory = $false)]
        [ValidateSet('Env','PS')]
        [string] $variableType = 'PS'
    )

    switch ($variableType) {
        'PS' {
            Get-Variable $variableName -ValueOnly
        }        
        'Env' {
            (Get-Childitem env: | Where-Object {$_.Name -eq $variableName}).Value
        }        
    }
        
}