# Create `fs` connector

Initializes the connector for file system type of storage. See
[ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md)
for details.

## Usage

``` r
connector_fs(path, extra_class = NULL)
```

## Arguments

- path:

  [character](https://rdrr.io/r/base/character.html) Path to the file
  storage.

- extra_class:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector.

## Value

A new
[ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md)
object

## Details

The `extra_class` parameter allows you to create a subclass of the
`ConnectorFS` object. This can be useful if you want to create a custom
connection object for easier dispatch of new s3 methods, while still
inheriting the methods from the `ConnectorFS` object.

## Examples

``` r
# Create FS connector
cnt <- connector_fs(tempdir())
cnt
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

# Create subclass connection
cnt_subclass <- connector_fs(
  path = tempdir(),
  extra_class = "subclass"
)
cnt_subclass
#> <subclass/ConnectorFS>
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
class(cnt_subclass)
#> [1] "subclass"    "ConnectorFS" "Connector"   "R6"         
```
