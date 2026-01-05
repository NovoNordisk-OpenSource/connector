# Upload content to the connector

Generic implementing of how to upload files to a connector:

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses [`fs::file_copy()`](https://fs.r-lib.org/reference/copy.html) to
  copy the `file` to the file storage.

&nbsp;

- [ConnectorLogger](https://novonordisk-opensource.github.io/connector/reference/ConnectorLogger.md):
  Logs the upload operation and calls the underlying connector method.

## Usage

``` r
upload_cnt(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
)

# S3 method for class 'ConnectorFS'
upload_cnt(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
)

# S3 method for class 'ConnectorLogger'
upload_cnt(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- src:

  [character](https://rdrr.io/r/base/character.html) Path to the file to
  download to or upload from

- dest:

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
# Upload file to a file storage

writeLines("this is an example", "example.txt")

folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)

cnt |>
  list_content_cnt(pattern = "example.txt")
#> character(0)

cnt |>
  upload_cnt("example.txt")

cnt |>
  list_content_cnt(pattern = "example.txt")
#> [1] "example.txt"

cnt |>
  remove_cnt("example.txt")

file.remove("example.txt")
#> [1] TRUE

# Add logging to a file system connector for uploads
folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connectors(data = connector_fs(folder)) |> add_logs()

# Create a temporary file
temp_file <- tempfile(fileext = ".csv")
write.csv(iris, temp_file, row.names = FALSE)

cnt$data |>
  upload_cnt(temp_file, "uploaded_iris.csv")
#> {"time":"2026-01-05 12:31:07","type":"write","file":"uploaded_iris.csv @ /tmp/RtmpAUXnEM/test1d57129a5828"}
```
