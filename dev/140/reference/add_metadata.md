# Add metadata to a YAML configuration file

This function adds metadata to a YAML configuration file by modifying
the provided key-value pair in the metadata section of the file.

## Usage

``` r
add_metadata(config_path, key, value)
```

## Arguments

- config_path:

  The file path to the YAML configuration file

- key:

  The key for the new metadata entry

- value:

  The value for the new metadata entry

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
  add_metadata(
    key = "new_metadata",
    value = "new_value"
  )
config
#> [1] "/tmp/Rtmp7x9gw0/file1dd449239ad3.yml"
```
