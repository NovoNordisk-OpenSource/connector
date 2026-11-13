# Remove a directory

Generic implementing of how to remove a directory for a connector.
Mostly relevant for file storage connectors.

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses [`fs::dir_delete()`](https://fs.r-lib.org/reference/delete.html)
  to remove a directory at the path of the connector.

## Usage

``` r
remove_directory_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorFS'
remove_directory_cnt(connector_object, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to remove

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.

## Examples

``` r
# Remove a directory from a file storage

folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)

cnt |>
  create_directory_cnt("new_folder")

cnt |>
  list_content_cnt(pattern = "new_folder")
#> [1] "new_folder"

cnt |>
  remove_directory_cnt("new_folder") |>
  list_content_cnt(pattern = "new_folder")
#> character(0)
```
