ImportJson
BeforeAll {
    $CommandName = 'Test-FatCsvHeaders.ps1'
    if (-not $ModulePath) { $ModulePath = join-path (join-path $PSScriptRoot "..") "adls2.folder.access.tools" }
    Get-Module adls2.folder.access.tools | remove-module
    $CommandNamePath = Resolve-Path (Join-Path $ModulePath /Private/$CommandName)
    Import-Module $CommandNamePath -Force
}

Describe "Test-FatCsvHeaders" -Tag 'Unit' {
    Context 'Valid Headers' {
        It "Function does not throw" {
            $csvPath = Join-Path $PSScriptRoot csvs/validcsv.csv
            [pscustomobject]@{ Container = 'lake';Folder = 'output';ADGroup='myadgroup';ADGroupID='';DefaultPermission='r-x';AccessPermission='rwx';Recurse='False'} | `
            Export-Csv -Path  $csvPath -NoTypeInformation -UseQuotes Never
            {Test-FatCsvHeaders -csvPath $csvPath } | Should -Not -Throw
        }
        It "Function does throw; headers do not match" {
            Mock Write-Host {
                Return
            }
            $csvPath = Join-Path $PSScriptRoot csvs/wrongheaders.csv
            [pscustomobject]@{ Contrainer = 'lake';Folder = 'output';ADGroup='myadgroup';ADGroupID='';DefaultPermission='r-x';AccessPermission='rwx';Recurse='False'} | `
            Export-Csv -Path  $csvPath -NoTypeInformation -UseQuotes Never
            {Test-FatCsvHeaders -csvPath $csvPath} | Should -Throw 
            Assert-MockCalled Write-Host -Exactly 1
        }

        It "Function does throw; less than 7 headers" {
            Mock Write-Host {
                Return
            }
            $csvPath = Join-Path $PSScriptRoot csvs/wrongheaders.csv
            [pscustomobject]@{ Container = 'lake';Folder = 'output';ADGroup='myadgroup';ADGroupID='';IncludeInDefault='False';Recurse='False'} | `
            Export-Csv -Path  $csvPath -NoTypeInformation -UseQuotes Never
            {Test-FatCsvHeaders -csvPath $csvPath} | Should -Throw 
            Assert-MockCalled Write-Host -Exactly 1
        }

        It "Whitespace in headers" {
            $csvPath = Join-Path $PSScriptRoot csvs/whitespaceheaders.csv
            [pscustomobject]@{ "      Container" = 'lake';Folder = 'output';ADGroup='myadgroup';ADGroupID='';DefaultPermission='r-x';AccessPermission='rwx';Recurse='False'} | `
            Export-Csv -Path  $csvPath -NoTypeInformation -UseQuotes Never
            {Test-FatCsvHeaders -csvPath $csvPath} | Should -Not -Throw 
        }
    }
}


