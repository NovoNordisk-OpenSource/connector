# Remove a datasource from a YAML configuration file

This function removes a datasource from a YAML configuration file based
on the provided name, ensuring that it doesn't interfere with other
existing datasources.

## Usage

``` r
remove_datasource(config_path, name)
```

## Arguments

- config_path:

  The file path to the YAML configuration file

- name:

  The name of the datasource to be removed

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
# Add a datasource first
config <- config |>
  add_datasource(
    name = "new_datasource",
    backend = list(type = "connector_fs", path = "new_path")
  )
config
#> [1] "/tmp/Rtmptz0BAX/file1ee7ddce2e1.yml"
# Now remove it
config <- config |>
  remove_datasource("new_datasource")
config
#> [1] "/tmp/Rtmptz0BAX/file1ee7ddce2e1.yml"
```
