# Add a new datasource to a YAML configuration file

This function adds a new datasource to a YAML configuration file by
appending the provided datasource information to the existing
datasources.

## Usage

``` r
add_datasource(config_path, name, backend)
```

## Arguments

- config_path:

  The file path to the YAML configuration file

- name:

  The name of the new datasource

- backend:

  A named list representing the backend configuration for the new
  datasource

## Value

(invisible) `config_path` where the configuration have been updated

## Examples

``` r
config <- tempfile(fileext = ".yml")

file.copy(
  from = system.file("config", "_connector.yml", package = "connector"),
  to = config
)
#> [1] TRUE

config <- config |>
  add_datasource(
    name = "new_datasource",
    backend = list(type = "connector_fs", path = "new_path")
  )
config
#> [1] "/tmp/RtmpAUXnEM/file1d5712859445.yml"
```
