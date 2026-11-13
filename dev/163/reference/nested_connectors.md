# Create a nested connectors object

This function creates a nested connectors object from the provided
arguments.

## Usage

``` r
nested_connectors(...)
```

## Arguments

- ...:

  Any number of named
  [`connectors()`](https://novonordisk-opensource.github.io/connector/reference/connectors.md)
  objects.

## Value

A list with class "nested_connectors" containing the provided arguments.

## Examples

``` r
nested_connectors(
  trial_1 = connectors(
    sdtm = connector_fs(path = tempdir())
  ),
  trial_2 = connectors(
    sdtm = connector_dbi(drv = RSQLite::SQLite())
  )
)
#> <connector::nested_connectors/list/S7_object>
#>   $trial_1 <connector::connectors>
#>   $trial_2 <connector::connectors>
```
