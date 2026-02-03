# Download content from the connector

Generic implementing of how to download files from a connector:

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses [`fs::file_copy()`](https://fs.r-lib.org/reference/copy.html) to
  copy a file from the file storage to the desired `file`.

&nbsp;

- [ConnectorLogger](https://novonordisk-opensource.github.io/connector/reference/ConnectorLogger.md):
  Logs the download operation and calls the underlying connector method.

## Usage

``` r
download_cnt(connector_object, src, dest = basename(src), ...)

# S3 method for class 'ConnectorFS'
download_cnt(connector_object, src, dest = basename(src), ...)

# S3 method for class 'ConnectorLogger'
download_cnt(connector_object, src, dest = basename(src), ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- src:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- dest:

  [character](https://rdrr.io/r/base/character.html) Path to the file to
  download to or upload from

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.

## Examples

``` r
# Download file from a file storage

folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)

cnt |>
  write_cnt("this is an example", "example.txt")

list.files(pattern = "example.txt")
#> character(0)

cnt |>
  download_cnt("example.txt")

list.files(pattern = "example.txt")
#> [1] "example.txt"
readLines("example.txt")
#> [1] "this is an example"

cnt |>
  remove_cnt("example.txt")

# Add logging to a file system connector for downloads
folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connectors(data = connector_fs(folder)) |> add_logs()

cnt$data |>
  write_cnt(iris, "iris.csv")
#> {"time":"2026-02-03 10:05:53","type":"write","file":"iris.csv @ /tmp/RtmpRHFAeR/test1e1b74075afd"}

cnt$data |>
  download_cnt("iris.csv", tempfile(fileext = ".csv"))
#> {"time":"2026-02-03 10:05:53","type":"read","file":"iris.csv @ /tmp/RtmpRHFAeR/test1e1b74075afd"}
```
