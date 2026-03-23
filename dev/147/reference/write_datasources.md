# Write datasources attribute into a config file

Reproduce your workflow by creating a config file based on a connectors
object and the associated datasource attributes.

## Usage

``` r
write_datasources(connectors, file)
```

## Arguments

- connectors:

  A connectors object with associated "datasources" attribute.

- file:

  path to the config file

## Value

A config file with datasource attributes which can be reused in the
connect function

## Examples

``` r
folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connectors(fs = connector_fs(folder))

# Extract the datasources to a config file
yml_file <- tempfile(fileext = ".yml")
write_datasources(cnt, yml_file)
# Check the content of the file
cat(readLines(yml_file), sep = "\n")
#> datasources:
#> - name: fs
#>   backend:
#>     type: connector::connector_fs
#>     path: |
#>       Error in eval(.x) : object 'folder' not found
# Reconnect using the new config file
re_connect <- connect(yml_file)
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → fs
#> • connector::connector_fs
#> • Error in eval(.x) : object 'folder' not found
#> Error in purrr::map(config$datasources, create_connection): ℹ In index: 1.
#> Caused by error in `try_connect()`:
#> ! Problem in connection to the backend:
#> Error in validate_resource(self) : Invalid file system connector: Error in
#> eval(.x) : object 'folder' not found does not exist.
re_connect
#> Error: object 're_connect' not found
```
