$reset = $true

Install-Module platyPS -Scope CurrentUser
Import-Module platyPS
Set-Location $PSScriptRoot

Import-Module .\AssistDeploy.psd1 -Force
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
        $markdownLinks += "`n[$($m.BaseName)]($($m.BaseName))"
    } 
$homeContent = "`nWelcome to the AssistDeploy wiki!`n`nhttps://sabin.io/blog/assist-deploy-is-available-on-github/`n" + $markDownLinks
New-Item -Path $homeMarkdown -ItemType File -Value $homeContent -Force