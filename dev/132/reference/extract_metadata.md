# Extract metadata from connectors

This function extracts the "metadata" attribute from a connectors
object, with optional filtering to return only a specific metadata
field.

## Usage

``` r
extract_metadata(connectors, name = NULL)
```

## Arguments

- connectors:

  An object containing connectors with a "metadata" attribute.

- name:

  A character string specifying which metadata attribute to extract. If
  `NULL` (default), returns all metadata.

## Value

A list containing the metadata extracted from the "metadata" attribute,
or the specific attribute value if `name` is specified.

## Examples

``` r
# A config list with metadata
config <- list(
  metadata = list(
    study = "Example Study",
    version = "1.0"
  ),
  datasources = list(
    list(
      name = "adam",
      backend = list(type = "connector_fs", path = tempdir())
    )
  )
)

cnts <- connect(config)
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → adam
#> • connector_fs
#> • /tmp/RtmpjeBf7Q

# Extract all metadata
result <- extract_metadata(cnts)
print(result)
#> $study
#> [1] "Example Study"
#> 
#> $version
#> [1] "1.0"
#> 

# Extract specific metadata field
study_name <- extract_metadata(cnts, name = "study")
print(study_name)
#> [1] "Example Study"
```
