# Extract data sources from connectors

This function extracts the "datasources" attribute from a connectors
object.

## Usage

``` r
list_datasources(connectors)
```

## Arguments

- connectors:

  An object containing connectors with a "datasources" attribute.

## Value

An object containing the data sources extracted from the "datasources"
attribute.

## Details

The function uses the [`attr()`](https://rdrr.io/r/base/attr.html)
function to access the "datasources" attribute of the `connectors`
object. It directly returns this attribute without any modification.

## Examples

``` r
# Connectors object with data sources
cnts <- connectors(
  sdtm = connector_fs(path = tempdir()),
  adam = connector_dbi(drv = RSQLite::SQLite())
)

# Using the function (returns datasources attribute)
result <- list_datasources(cnts)
# Check if result contains datasource information
result$datasources
#> [[1]]
#> [[1]]$name
#> [1] "sdtm"
#> 
#> [[1]]$backend
#> [[1]]$backend$type
#> [1] "connector::connector_fs"
#> 
#> [[1]]$backend$path
#> [1] "/tmp/Rtmptz0BAX"
#> 
#> 
#> 
#> [[2]]
#> [[2]]$name
#> [1] "adam"
#> 
#> [[2]]$backend
#> [[2]]$backend$type
#> [1] "connector::connector_dbi"
#> 
#> [[2]]$backend$drv
#> [1] "RSQLite::SQLite()"
#> 
#> 
#> 
```
