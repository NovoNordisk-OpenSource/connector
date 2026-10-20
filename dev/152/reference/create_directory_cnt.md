# Create a directory

Generic implementing of how to create a directory for a connector.
Mostly relevant for file storage connectors.

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses [`fs::dir_create()`](https://fs.r-lib.org/reference/create.html)
  to create a directory at the path of the connector.

## Usage

``` r
create_directory_cnt(connector_object, name, open = TRUE, ...)

# S3 method for class 'ConnectorFS'
create_directory_cnt(connector_object, name, open = TRUE, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to create

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
# Create a directory in a file storage

folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)

cnt |>
  list_content_cnt(pattern = "new_folder")
#> character(0)

cnt |>
  create_directory_cnt("new_folder")

# This will return new connector object of a newly created folder
new_connector <- cnt |>
  list_content_cnt(pattern = "new_folder")

cnt |>
  remove_directory_cnt("new_folder")
```
