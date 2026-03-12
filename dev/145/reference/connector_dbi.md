# Create `dbi` connector

Initializes the connector for DBI type of storage. See
[ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md)
for details.

## Usage

``` r
connector_dbi(drv, ..., extra_class = NULL)
```

## Arguments

- drv:

  Driver object inheriting from
  [DBI::DBIDriver](https://dbi.r-dbi.org/reference/DBIDriver-class.html).

- ...:

  Additional arguments passed to
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).

- extra_class:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector.

## Value

A new
[ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md)
object

## Details

The `extra_class` parameter allows you to create a subclass of the
`ConnectorDBI` object. This can be useful if you want to create a custom
connection object for easier dispatch of new s3 methods, while still
inheriting the methods from the `ConnectorDBI` object.

## Examples

``` r
# Create DBI connector
cnt <- connector_dbi(RSQLite::SQLite(), ":memory:")
cnt
#> <ConnectorDBI>
#> Inherits from: <Connector>
#> Registered methods:
#> • `disconnect_cnt.ConnectorDBI()`
#> • `list_content_cnt.ConnectorDBI()`
#> • `log_read_connector.ConnectorDBI()`
#> • `log_remove_connector.ConnectorDBI()`
#> • `log_write_connector.ConnectorDBI()`
#> • `read_cnt.ConnectorDBI()`
#> • `remove_cnt.ConnectorDBI()`
#> • `tbl_cnt.ConnectorDBI()`
#> • `write_cnt.ConnectorDBI()`
#> • `check_resource.Connector()`
#> Specifications:
#> • conn: <SQLiteConnection>

# Create subclass connection
cnt_subclass <- connector_dbi(RSQLite::SQLite(), ":memory:",
  extra_class = "subclass"
)
cnt_subclass
#> <subclass/ConnectorDBI>
#> Inherits from: <Connector>
#> Registered methods:
#> • `disconnect_cnt.ConnectorDBI()`
#> • `list_content_cnt.ConnectorDBI()`
#> • `log_read_connector.ConnectorDBI()`
#> • `log_remove_connector.ConnectorDBI()`
#> • `log_write_connector.ConnectorDBI()`
#> • `read_cnt.ConnectorDBI()`
#> • `remove_cnt.ConnectorDBI()`
#> • `tbl_cnt.ConnectorDBI()`
#> • `write_cnt.ConnectorDBI()`
#> • `check_resource.Connector()`
#> Specifications:
#> • conn: <SQLiteConnection>
class(cnt_subclass)
#> [1] "subclass"     "ConnectorDBI" "Connector"    "R6"          
```
