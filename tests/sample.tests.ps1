Set-Location $PSScriptRoot
$Config = (Get-Content '.\config.json' | ConvertFrom-Json)

Describe "sample test" {
    it "null is null" {
        
        $null | Should -Be $null
    }
}