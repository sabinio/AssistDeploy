$sioEverest = "bob"
$sioSnowdon = "jim"
Import-Module C:\Users\RichardLee\source\repos\AssistDeploy -Force

$whatIS = Import-Json -jsonPath "C:\Users\RichardLee\source\repos\AssistDeploy\Daily_ETL.json"

Write-Host $whatIS.SsisEnvironmentVariable[0]