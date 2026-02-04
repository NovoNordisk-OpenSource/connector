# Upload a directory

Generic implementing of how to upload a directory for a connector.
Mostly relevant for file storage connectors.

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses [`fs::dir_copy()`](https://fs.r-lib.org/reference/copy.html).

## Usage

``` r
upload_directory_cnt(
  connector_object,
  src,
  dest,
  overwrite = zephyr::get_option("overwrite", "connector"),
  open = FALSE,
  ...
)

# S3 method for class 'ConnectorFS'
upload_directory_cnt(
  connector_object,
  src,
  dest,
  overwrite = zephyr::get_option("overwrite", "connector"),
  open = FALSE,
  ...
)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- src:

  [character](https://rdrr.io/r/base/character.html) Path to the
  directory to upload

- dest:

  [character](https://rdrr.io/r/base/character.html) The name of the new
  directory to place the content in

- overwrite:

  Overwrite existing content if it exists in the connector? See
  [connector-options](https://novonordisk-opensource.github.io/connector/reference/connector-options.md)
  for details. Default can be set globally with
  `options(connector.overwrite = TRUE/FALSE)` or environment variable
  `R_CONNECTOR_OVERWRITE`.. Default: `FALSE`.

- open:

  [logical](https://rdrr.io/r/base/logical.html) Open the directory as a
  new connector object.

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.

## Examples

``` r
# Upload a directory to a file storage
folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)
# Create a source directory
dir.create(file.path(folder, "src_dir"))
writeLines(
  "This is a test file.",
  file.path(folder, "src_dir", "test.txt")
)
# Upload the directory
cnt |>
  upload_directory_cnt(
    src = file.path(folder, "src_dir"),
    dest = "uploaded_dir"
  )
```
