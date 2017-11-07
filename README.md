

[<img src="https://sabinio.visualstudio.com/_apis/public/build/definitions/573f7b7f-2303-49f0-9b89-6e3117380331/105/badge"/>](https://sabinio.visualstudio.com/Sabin.IO/_apps/hub/ms.vss-ciworkflow.build-ci-hub?_a=edit-build-definition&id=105)

AUTHOR: Richie Lee 

# SSIS Deploy PowerShell Module Guide

## Introduction
This module will take an ispac file and deploy the dtsx packages contained within the ispac to an Integration Services Catalog. In addtion, because a SSIS Project requires more than just the dtsx packages (more on this later), this module aims to deploy these objects stored within a json file. The module also attempts to deploy all objects in such a way that it is idempotent.
Each one of the functions contained have their own documentation in the header of the function. This readme will attempt to expand up on that documentation, But is is strongly encouraged that you read the header documentation within each function to understand better what is going on.

## Sample
There is a sample repo [here](https://github.com/sabinio/AssistDeploy_WWI_SSIS_Samples)

## What is in the json file?
As mentioned, there is more than just the dtsx packages that need to be deployed. Before a project can be deployed, a folder needs to be created. And if a SSIS project uses parameters, then the parameters of a project, be they at a project or package level, will need an environment variable, so that we can deploy the same ispac to different environments. And before an environment variable can be created, an environment needs to be created, with an environment reference between the environment and the project. 

Because there is no way provided by Microsoft to include this information with a SSIS Project, it is necessary to provide this information someway along with the ispac, using the publish.xml file used by SSDT as inspiration, the publish.json file will store this information that will then be used by the ssisDeploy module to deploy these objects to an Integration Services Catalog.

## What is the structure for the publish.json file?
The template of the json is below:
```json

{
    "integrationServicesCatalog": {
        "ssisFolderName": "",
        "ssisEnvironmentName": "",
        "ssisProjectName": "",
        "ssisEnvironmentDescription": ""
    },
    "ssisEnvironmentVariable": [
        {
            "variableName": "",
            "dataType": "",
            "isSensitive": ,
            "value": "",
            "description": "",
            "parameter": [
                {
                    "parameterType": "",
                    "packageName": "",
                    "parameterName": ""
                }
            ]
        }
    ]
}
```
The json has a section that declares the folder/project/environment/environment description which is used throuhgout the deployment process. These can be overwritten by the functions if necessary. Any parameter, either package or project, will reference an environment variable. So all parameters have parents that are an environment variable. Whether a parameter is a package or project only matters in one sense: a package parameter will have to include a "objectName" string with the value set to the package it exists in. The "value" of each parameter will be the "variableName".

Below is an example of just two project parameters with two environment variables. 
```json
{
    "IntegrationServicesCatalog": {
        "ssisEnvironmentName": "Nevis",
        "ssisProjectName": "Daily ETL",
        "ssisFolderName": "ssis_guy",
        "ssisEnvironmentDescription": "sample ETL process that only uses databases"
    },
    "SsisEnvironmentVariable": [
        {
            "isSensitive": false,
            "description": "",
            "VariableName": "sioEverest",
            "value": "Data Source=fakeinstance.database.windows.net;User ID=fakesa;Password=fakepassword123;Initial Catalog=sioEverestDb;Provider=SQLNCLI11.1;Persist Security Info=True;Auto Translate=False;",
            "dataType": "String",
            "parameter": [
                {
                    "parameterType": "project",
                    "parameterName": "SioEverest_DW_Destination_DB_ConnectionString"
                }
            ]
        },
        {
            "isSensitive": false,
            "description": "",
            "VariableName": "sioSnowdon",
            "value": "Data Source=fakeinstance.database.windows.net;User ID=faskesa;Password=faksepassword123;Initial Catalog=sioSnowdonDb;Provider=SQLNCLI11.1;Persist Security Info=True;Auto Translate=False;",
            "dataType": "String",
            "parameter": [
                {
                    "parameterType": "project",
                    "parameterName": "SioSnowdon_Source_DB_ConnectionString"
                }
            ]
        }
    ]
}

```

Here is another example that has one project parameter, and one package parameter that is re-used in packages. Note it is not recommended that you have a package parameter that is re-used throughout different packages. But if you do indeed have such a feature the deployment process will support it.

```json
{
    "integrationServicesCatalog": {
        "ssisFolderName": "ssis_guy",
        "ssisEnvironmentName": "terrain",
        "ssisProjectName": "ssis_guy",
        "ssisEnvironmentDescription": "this is the description of the environment"
    },
    "ssisEnvironmentVariable": [
        {
            "variableName": "my_varFolderName2",
            "dataType": "String",
            "isSensitive": false,
            "value": "C:\\New_New_New_Sample_Data",
            "description": "I have updated the description, should be same difference.",
            "parameter": [
                {
                    "parameterType": "Package",
                    "objectName": "Lesson 7.dtsx",
                    "parameterName": "VarFolderName",
                },
                {
                    "parameterType":"Package",
                    "objectName": "Lesson 9.dtsx",
                    "parameterName": "VarFolderName",
                }
            ]
        },
        {
            "variableName": "var_LocalHostAdventureWorksDW2012_ConnectionString",
            "dataType": "String",
            "isSensitive": false,
            "value": "Data Source=.\\sixteen;Initial Catalog=AdventureWorksDW2012;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;",
            "description": "my connection string",
            "parameter": [
                {
                    "parameterType": "Project",
                    "parameterName": "LocalHostAdventureWorksDW2012_ConnectionString"
                }
            ]
        }
    ]
}
```

## If Values Are Hard-coded in json file, how can I deploy to other environments?
All the functions marked "Publish" require that the json file is passed in. This is then loaded as a json object in the function. For json objects under "Integration Services Catalog", the overwrite of the values is quite simple. So if we wish to alter the folder/environment/environment description, there are optional parameters that override what is in the json file. Consult the documentation headers in the functions for more info/working examples

For the values of variables under ssisEnvironmentVariables, the process is only slightly more complex. It is only the value of "value"  that will change; this is where the actual value of both environment and parameters is stored. All other values should remain constant.
In "Publish-SsisVariables" there is a switch called -localVariables. If this is included when calling the function then the values within the json file will be used when publishing variables to the Integration Services Catalog. However if this switch is not included then a PowerShell variable with the exact same name as the varaibleName must exist in the same session, and the value of this Powershell parameter overwrites the value in the json file in memory. 

To see this in action, refer to PublishSsisVariables.ps1. An example of how this works is provided below:
```powershell
$my_variable = "this is the value of my_variable"

if (Test-Path variable:my_variable) {
    Write-Host $my_variable -ForegroundColor Magenta -BackgroundColor Yellow
}
else {
    Write-Host 'Variable $my_variable does not exist.' -ForegroundColor Yellow -BackgroundColor Magenta
}
#note: my_non_existent_variable doesn't exist, so will go to else statement
if (Test-Path variable:my_non_existent_variable) {
    Write-Host $my_non_existent_variable -ForegroundColor Magenta -BackgroundColor Yellow
}
else {
    Write-Host 'Variable $my_non_existent_variable does not exist.' -ForegroundColor Yellow -BackgroundColor Magenta
}
```
The idea of localvariables was so that this module could be used both on a developers box and as part of a deploy pipeline run by TeamCity/Octpus/Jenkins etc.

## This json File Seems Like A Lot Of Effort To Create...
In deference to the fact that the json file can be quite difficult to create, there is a function that will import a project currently on an Integration Services Catalog into the json format required by the module. The idea here is that a developer is working on a local instance, deploying the ispac and creating environment variables for parameters. After they have completed their work they can extract the json and ddeploy locally to verify that hte changes are correct. This means that the json should not have to be written by hand, ever.

## Export SSIS Project to json File
For example, if I wanted to create the json for the first example above, I would run the following:
```powershell
cls
Import-Module ..\ps_module\SsisDeploy -Force
$svr = "Server=.;Integrated Security=True"
$ssisdb = Connect-SsisdbSql -sqlConnectionString $svr
$projectName = "Daily ETL"
$environmentname = "nevis"
$foldername = "ssis_guy"
$desc = "sample ETL process that only uses databases"
$myJsonObject = Get-SsisAsJson -sqlConnection $ssisdb -ssisEnvironment $environmentname -ssisFolder $foldername -ssisProject $projectName -ssisEnvironmentDescription $desc
$myJsonObject | out-file ".\Daily_ETL.json"
```

## How To Deploy SSIS Project 
Below is a simple deployment process. It makes use of all values stored in the project itself.
```powershell
Import-Module ..\ps_module\SsisDeploy -Force
#the name of the json file that has all of the environment references/variables used by the ssis packages.
$thisSsisPublishFilePath = ".\Daily_ETL.json"
#test ispac.
$thisIspacToDeploy = ".\readme\Daily_ETL.ispac"
#connection to instance that has integration services and ssisdb
$svr = "Server=.;Integrated Security=True"
#create a connection used throughout the process.
$myJsonPublishProfile = Import-Json -path $thisSsisPublishFilePath -localVariables
$ssisdb = Connect-SsisdbSql -sqlConnectionString $svr
Publish-SsisFolder -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb
Publish-SsisEnvironment -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb
Publish-SsisIspac -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb -ispacToDeploy $thisIspacToDeploy
Publish-SsisVariables -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb -localVariables
Publish-SsisEnvironmentReference -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb
Disconnect-SsisdbSql -sqlConnection $ssisdb
```

This example requires PowerShell variables that have the same name as each of the variables in ssisEnvironmentVariable:
```powershell
#the name of the json file that has all of the environment references/variables used by the ssis packages.
$thisSsisPublishFilePath = ".\Daily_ETL.json"
#test ispac.
$thisIspacToDeploy = ".\readme\Daily_ETL.ispac"
#connection to instance that has integration services and ssisdb
$svr = "Server=.;Integrated Security=True"
#create a connection used throughout the process.
[string]$my_varFolderName2 = "bob"
[string]$var_LocalHostAdventureWorksDW2012_ConnectionString = "something else"
$myJsonPublishProfile = Import-Json -path $thisSsisPublishFilePath
$ssisdb = Connect-SsisdbSql -sqlConnectionString $svr
Publish-SsisFolder -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb
Publish-SsisEnvironment -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb
Publish-SsisIspac -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb -ispacToDeploy $thisIspacToDeploy
Publish-SsisVariables -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb -localVariables
Publish-SsisEnvironmentReference -jsonPsCustomObject $myJsonPublishProfile -sqlConnection $ssisdb
Disconnect-SsisdbSql -sqlConnection $ssisdb
```
