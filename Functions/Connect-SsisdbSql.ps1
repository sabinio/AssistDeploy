function Connect-SsisdbSql {
    <#
.Synopsis
create a connection to sql instance
.Description
Using sqldataclient.sqlconnection, create a connection to sql instance
Set database to ssisdb
return connection
.Parameter sqlConnectionString
The SQL Connection as a string that we use to make object SqlConnection
.Example
Connect-SsisdbSql -sqlConnectionString "Server=.;Integrated Security=True"
#>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [string] $sqlConnectionString)

    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection ($sqlConnectionString)
    try {
        $sqlConnection.Open()
        $sqlConnection.ChangeDatabase("SSISDB")
        return $sqlConnection
    }
    catch {
        Throw $_.Exception
    }
}