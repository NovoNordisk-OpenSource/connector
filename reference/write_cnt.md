# Write content to the connector

Generic implementing of how to write content to the different connector
objects:

- [ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md):
  Uses
  [`DBI::dbWriteTable()`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
  to write the table to the DBI connection.

&nbsp;

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses
  [`write_file()`](https://novonordisk-opensource.github.io/connector/reference/write_file.md)
  to Write a file based on the file extension. The underlying function
  used, and thereby also the arguments available through `...` depends
  on the file extension.

If no file extension is provided in the `name`, the default extension
will be automatically appended (configurable via
`options(connector.default_ext = "csv")`, defaults to "csv").

- [ConnectorLogger](https://novonordisk-opensource.github.io/connector/reference/ConnectorLogger.md):
  Logs the write operation and calls the underlying connector method.

## Usage

``` r
write_cnt(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
)

# S3 method for class 'ConnectorDBI'
write_cnt(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
)

# S3 method for class 'ConnectorFS'
write_cnt(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
)

# S3 method for class 'ConnectorLogger'
write_cnt(connector_object, x, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- x:

  The object to write to the connection

- name:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- overwrite:

  Overwrite existing content if it exists in the connector? See
  [connector-options](https://novonordisk-opensource.github.io/connector/reference/connector-options.md)
  for details. Default can be set globally with
  `options(connector.overwrite = TRUE/FALSE)` or environment variable
  `R_CONNECTOR_OVERWRITE`.. Default: `FALSE`.

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.

## Examples

``` r
# Write table to DBI database
cnt <- connector_dbi(RSQLite::SQLite())

cnt |>
  list_content_cnt()
#> character(0)

cnt |>
  write_cnt(iris, "iris")

cnt |>
  list_content_cnt()
#> [1] "iris"

# Write different file types to a file storage

folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)

cnt |>
  list_content_cnt(pattern = "iris")
#> character(0)

# rds file
cnt |>
  write_cnt(iris, "iris.rds")

# CSV file
cnt |>
  write_cnt(iris, "iris.csv")

cnt |>
  list_content_cnt(pattern = "iris")
#> [1] "iris.csv" "iris.rds"

# Add logging to a database connector
cnt <- connectors(data = connector_dbi(RSQLite::SQLite())) |> add_logs()

cnt$data |>
  write_cnt(mtcars, "cars")
#> {"time":"2026-02-03 10:05:59","type":"write","file":"cars @ driver: SQLiteConnection, dbname: "}
```
