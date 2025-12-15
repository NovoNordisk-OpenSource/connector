# Collection of connector objects

Holds a special list of individual connector objects for consistent use
of connections in your project.

## Usage

``` r
connectors(...)
```

## Arguments

- ...:

  Named individual
  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  objects

## Examples

``` r
# Create connectors objects

cnts <- connectors(
  sdtm = connector_fs(path = tempdir()),
  adam = connector_dbi(drv = RSQLite::SQLite())
)

# Print for overview

cnts
#> <connectors>
#>   $sdtm <ConnectorFS>
#>   $adam <ConnectorDBI>

# Print the individual connector for more information

cnts$sdtm
#> <ConnectorFS>
#> Inherits from: <Connector>
#> Registered methods:
#> • `check_resource.ConnectorFS()`
#> • `create_directory_cnt.ConnectorFS()`
#> • `download_cnt.ConnectorFS()`
#> • `download_directory_cnt.ConnectorFS()`
#> • `list_content_cnt.ConnectorFS()`
#> • `log_read_connector.ConnectorFS()`
#> • `log_remove_connector.ConnectorFS()`
#> • `log_write_connector.ConnectorFS()`
#> • `read_cnt.ConnectorFS()`
#> • `remove_cnt.ConnectorFS()`
#> • `remove_directory_cnt.ConnectorFS()`
#> • `tbl_cnt.ConnectorFS()`
#> • `upload_cnt.ConnectorFS()`
#> • `upload_directory_cnt.ConnectorFS()`
#> • `write_cnt.ConnectorFS()`
#> Specifications:
#> • path: /tmp/Rtmptz0BAX

cnts$adam
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
```
