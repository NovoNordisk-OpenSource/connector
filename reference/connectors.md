# Collection of connector objects

Holds a special list of individual connector objects for consistent use
of connections in your project.

## Usage

``` r
connectors(..., .metadata = list(), .datasources = NULL)
```

## Arguments

- ...:

  Named individual
  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  objects.

- .metadata:

  [`list()`](https://rdrr.io/r/base/list.html) of named metadata to
  store in the `@metadata` property.

- .datasources:

  [`list()`](https://rdrr.io/r/base/list.html) of datasource
  specifications to store in the `@datasources` property. If `NULL`
  (default) will be derived based on `...` input.

## Examples

``` r
# Create connectors objects

cnts <- connectors(
  sdtm = connector_fs(path = tempdir()),
  adam = connector_dbi(drv = RSQLite::SQLite())
)

# Print for overview

cnts
#> <connector::connectors/list/S7_object>
#>   $sdtm <ConnectorFS>
#>   $adam <ConnectorDBI>

# Print the individual Connector for more information

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
#> • path: /tmp/RtmpNYgVLi

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
