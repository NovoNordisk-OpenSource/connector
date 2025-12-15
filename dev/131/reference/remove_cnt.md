# Remove content from the connector

Generic implementing of how to remove content from different connectors:

- [ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md):
  Uses
  [`DBI::dbRemoveTable()`](https://dbi.r-dbi.org/reference/dbRemoveTable.html)
  to remove the table from a DBI connection.

&nbsp;

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses [`fs::file_delete()`](https://fs.r-lib.org/reference/delete.html)
  to delete the file.

&nbsp;

- [ConnectorLogger](https://novonordisk-opensource.github.io/connector/reference/ConnectorLogger.md):
  Logs the remove operation and calls the underlying connector method.

## Usage

``` r
remove_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDBI'
remove_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorFS'
remove_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorLogger'
remove_cnt(connector_object, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.

## Examples

``` r
# Remove table in a DBI database
cnt <- connector_dbi(RSQLite::SQLite())

cnt |>
  write_cnt(iris, "iris") |>
  list_content_cnt()
#> [1] "iris"

cnt |>
  remove_cnt("iris") |>
  list_content_cnt()
#> character(0)

# Remove a file from the file storage

folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)

cnt |>
  write_cnt("this is an example", "example.txt")
cnt |>
  list_content_cnt(pattern = "example.txt")
#> [1] "example.txt"

cnt |>
  read_cnt("example.txt")
#> [1] "this is an example"

cnt |>
  remove_cnt("example.txt")

cnt |>
  list_content_cnt(pattern = "example.txt")
#> character(0)

# Add logging to a connector and remove content
folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connectors(data = connector_fs(folder)) |> add_logs()

cnt$data |>
  write_cnt(iris, "iris.csv")
#> {"time":"2025-12-15 12:16:42","type":"write","file":"iris.csv @ /tmp/RtmplYQFR2/test1b03747247d4"}

cnt$data |>
  remove_cnt("iris.csv")
#> {"time":"2025-12-15 12:16:42","type":"delete","file":"iris.csv @ /tmp/RtmplYQFR2/test1b03747247d4"}
```
