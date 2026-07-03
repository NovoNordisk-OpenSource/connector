# Create a New Connector Logger

Creates a new empty connector logger object of class "ConnectorLogger".
This is an internal utility class that initializes a logging structure
for connector operations. Logs are added to connectors using
[`add_logs()`](https://novonordisk-opensource.github.io/connector/reference/add_logs.md).

## Usage

``` r
ConnectorLogger

# S3 method for class 'ConnectorLogger'
print(x, ...)
```

## Format

An object of class `ConnectorLogger` of length 0.

## Arguments

- x:

  object to print

- ...:

  parameters passed to the print method

## Value

An S3 object of class "ConnectorLogger" containing:

- An empty list

- Class attribute set to "ConnectorLogger"

## Details

Create a New Connector Logger

## Examples

``` r
logger <- ConnectorLogger
class(logger) # Returns "ConnectorLogger"
#> [1] "ConnectorLogger"
str(logger) # Shows empty list with class attribute
#>  list()
#>  - attr(*, "class")= chr "ConnectorLogger"
```
