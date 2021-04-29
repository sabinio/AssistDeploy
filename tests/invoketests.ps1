
Install-Module Pester -MinimumVersion 4.4.2 -Scope CurrentUser -SkipPublisherCheck -Force
Import-Module Pester -MinimumVersion 4.4.2

Set-Location $PSScriptRoot


$Edition = $PSVersionTable.PSEdition
$timeStamp = Get-Date -Format "dd_MM_yyyy_HH_mm"
Invoke-Pester -Script  .\*.tests.ps1 -OutputFile "TestResults-$Edition-$timeStamp.xml" -OutputFormat NUnitXML
