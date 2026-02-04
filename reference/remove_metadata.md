# Remove metadata from a YAML configuration file

This function removes metadata from a YAML configuration file by
deleting the specified key from the metadata section of the file.

## Usage

``` r
remove_metadata(config_path, key)
```

## Arguments

- config_path:

  The file path to the YAML configuration file

- key:

  The key for the metadata entry to be removed

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
# Add metadata first
config <- config |>
  add_metadata(
    key = "new_metadata",
    value = "new_value"
  )
config
#> [1] "/tmp/RtmpNYgVLi/file1dcd77140240.yml"
#' # Now remove it
config <- config |>
  remove_metadata("new_metadata")
config
#> [1] "/tmp/RtmpNYgVLi/file1dcd77140240.yml"
```
