function Test-Variable {
    <#
    .Synopsis
    Checks for existence of a variable
    .Description
    Checks for existence of a variable, which may be either a true powershell variable (e.g $Foo), or an environment variable (e.g $Env:Foo) 
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
            Test-Path variable:$variableName
        }        
        'Env' {
            Test-Path env:$variableName
        }        
    }
        
}