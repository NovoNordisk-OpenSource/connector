# List available content from the connector

Generic implementing of how to list all content available for different
connectors:

- [ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md):
  Uses
  [`DBI::dbListTables()`](https://dbi.r-dbi.org/reference/dbListTables.html)
  to list the tables in a DBI connection.

&nbsp;

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses [`list.files()`](https://rdrr.io/r/base/list.files.html) to list
  all files at the path of the connector.

&nbsp;

- [ConnectorLogger](https://novonordisk-opensource.github.io/connector/reference/ConnectorLogger.md):
  Logs the list operation and calls the underlying connector method.

## Usage

``` r
list_content_cnt(connector_object, ...)

# S3 method for class 'ConnectorDBI'
list_content_cnt(connector_object, ...)

# S3 method for class 'ConnectorFS'
list_content_cnt(connector_object, ...)

# S3 method for class 'ConnectorLogger'
list_content_cnt(connector_object, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

A [character](https://rdrr.io/r/base/character.html) vector of content
names

## Examples

``` r
# List tables in a DBI database
cnt <- connector_dbi(RSQLite::SQLite())

cnt |>
  list_content_cnt()
#> character(0)

# List content in a file storage
folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)

cnt |>
  list_content_cnt()
#> character(0)

#' # Write a file to the file storage
cnt |>
  write_cnt(iris, "iris.csv")

# Only list CSV files using the pattern argument of list.files

cnt |>
  list_content_cnt(pattern = "\\.csv$")
#> [1] "iris.csv"

# Add logging to a connector and list contents
folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connectors(data = connector_fs(folder)) |> add_logs()

cnt$data |>
  write_cnt(iris, "iris.csv")
#> {"time":"2026-01-05 16:18:35","type":"write","file":"iris.csv @ /tmp/RtmphrXHNe/test1d48701a951e"}

cnt$data |>
  list_content_cnt()
#> {"time":"2026-01-05 16:18:35","type":"read","file":". @ /tmp/RtmphrXHNe/test1d48701a951e"}
#> [1] "iris.csv"
```
