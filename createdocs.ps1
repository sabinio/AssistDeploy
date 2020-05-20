$reset = $true

Install-Module platyPS -Scope CurrentUser
Import-Module platyPS
Set-Location $PSScriptRoot
Import-Module .\AssistDeploy.psd1 -Force

if ((Test-Path ..\AssistDeploy.wiki\Home.md) -eq $false){
    Write-Host "Cloning wiki repo..."
    Push-Location 
    Set-Location ..\
    git clone https://github.com/sabinio/AssistDeploy.wiki.git
    Pop-Location
}

if ($reset) {
    $files = Get-ChildItem .\Functions -Filter *.ps1
    foreach ($f in $files) {
        New-MarkdownHelp -Command $f.BaseName -OutputFolder ..\AssistDeploy.wiki -force
    }
}
else {
    Update-MarkdownHelp ..\AssistDeploy.wiki
}

$homeMarkdown = Resolve-Path ..\AssistDeploy.wiki\Home.md
$markDownFiles = Get-ChildItem ..\AssistDeploy.wiki -Exclude "Home.md"
    foreach ($m in $markDownFiles) {
        $markdownLinks += "`n[$($m.BaseName)]($($m.BaseName))`n"
    } 
$homeContent = "`nWelcome to the AssistDeploy wiki!`n`nI've written a post about [Assist Deploy](https://sabin.io/blog/assist-deploy-is-available-on-github/) being released.`n" + $markDownLinks
New-Item -Path $homeMarkdown -ItemType File -Value $homeContent -Force