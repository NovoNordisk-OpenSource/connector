# Download a directory

Generic implementing of how to download a directory for a connector.
Mostly relevant for file storage connectors.

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses [`fs::dir_copy()`](https://fs.r-lib.org/reference/copy.html).

## Usage

``` r
download_directory_cnt(connector_object, src, dest = basename(src), ...)

# S3 method for class 'ConnectorFS'
download_directory_cnt(connector_object, src, dest = basename(src), ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- src:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to download from the connector

- dest:

  [character](https://rdrr.io/r/base/character.html) Path to the
  directory to download to

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.

## Examples

``` r
# Download a directory to a file storage
folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)
# Create a source directory
dir.create(file.path(folder, "src_dir"))
writeLines(
  "This is a test file.",
  file.path(folder, "src_dir", "test.txt")
)
# Download the directory
cnt |>
 download_directory_cnt(
   src = "src_dir",
   dest = file.path(folder, "downloaded_dir")
  )
```
