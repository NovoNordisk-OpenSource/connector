# Disconnect (close) the connection of the connector

Generic implementing of how to disconnect from the relevant connections.
Mostly relevant for DBI connectors.

- [ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md):
  Uses
  [`DBI::dbDisconnect()`](https://dbi.r-dbi.org/reference/dbDisconnect.html)
  to create a table reference to close a DBI connection.

## Usage

``` r
disconnect_cnt(connector_object, ...)

# S3 method for class 'ConnectorDBI'
disconnect_cnt(connector_object, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.

## Examples

``` r
# Open and close a DBI connector
cnt <- connector_dbi(RSQLite::SQLite())

cnt$conn
#> <SQLiteConnection>
#>   Path: 
#>   Extensions: TRUE

cnt |>
  disconnect_cnt()

cnt$conn
#> <SQLiteConnection>
#>   DISCONNECTED
```
