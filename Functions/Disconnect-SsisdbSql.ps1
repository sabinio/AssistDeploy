function Disconnect-SsisdbSql {
    <#
.Synopsis
dispose of a connection to sql instance
.Description
Using sqldataclient.sqlconnection, dispose a connection to sql instance
Dispose method also calls close, so it return connection back to the pool
State of conection can be open, closed, broken, connecting, executing, fetching
.Parameter sqlConnection
The connection we wish to dispose of.
.Example
$mySqlConnection = "Server=.;Integrated Security=True"
Disconnect-SsisdbSql -sqlConnection $mySqlConnection
#>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] $sqlConnection)
    if ($sqlConnection.State -ne "Closed") {
        try {
            $sqlConnection.Dispose()
            Write-Verbose "Disposed of connection" -Verbose
            return
        }
        catch {
            Write-Error $_.Exception
            Throw
        }
    }
}
