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
