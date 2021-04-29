#Install-Module Pester -MinimumVersion 5.1.1 -MaximumVersion 5.1.1 -Scope CurrentUser -SkipPublisherCheck -Force
#Import-Module Pester -MinimumVersion 5.1.1 -MaximumVersion 5.1.1

Set-Location $PSScriptRoot
$Edition = $PSVersionTable.PSEdition
Invoke-Pester -CodeCoverage ../adls2.folder.access.tools/P*/*.ps1 -Path ./*.Tests.ps1  `
-OutputFile "$Edition-TestResults.xml" `
-OutputFormat NUnitXML `
-CodeCoverageOutputFile "coverage_$Edition-Results.xml"
Set-Location $PSScriptRoot