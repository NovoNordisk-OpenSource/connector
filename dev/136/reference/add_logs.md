# Add Logging Capability to Connections

This function adds logging capability to a list of connections by
modifying their class attributes. It ensures that the input is of the
correct type and registers the necessary S3 methods for logging.

## Usage

``` r
add_logs(connections)
```

## Arguments

- connections:

  An object of class
  [`connectors()`](https://novonordisk-opensource.github.io/connector/reference/connectors.md).
  This should be a list of connection objects to which logging
  capability will be added.

## Value

The modified `connections` object with logging capability added. Each
connection in the list will have the "ConnectorLogger" class prepended
to its existing classes.

## Details

The function performs the following steps:

1.  Checks if the input `connections` is of class "connectors".

2.  Iterates through each connection in the list and prepends the
    "ConnectorLogger" class.

## Examples

``` r
cnts <- connectors(
  sdtm = connector_fs(path = tempdir())
 )

logged_connections <- add_logs(cnts)

logged_connections
#> <connector::connectors/list/S7_object>
#>   $sdtm <ConnectorLogger>
```
