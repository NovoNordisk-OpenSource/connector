# General connector object

This R6 class is a general class for all connectors. It is used to
define the methods that all connectors should have. New connectors
should inherit from this class, and the methods described below should
be implemented.

## See also

[`vignette("customize")`](https://novonordisk-opensource.github.io/connector/articles/customize.md)
on how to create custom connectors and methods, and concrete examples in
[ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md)
and
[ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md).

## Methods

### Public methods

- [`Connector$new()`](#method-Connector-new)

- [`Connector$print()`](#method-Connector-print)

- [`Connector$list_content_cnt()`](#method-Connector-list_content_cnt)

- [`Connector$read_cnt()`](#method-Connector-read_cnt)

- [`Connector$write_cnt()`](#method-Connector-write_cnt)

- [`Connector$remove_cnt()`](#method-Connector-remove_cnt)

- [`Connector$clone()`](#method-Connector-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize the connector with the option of adding an extra class.

#### Usage

    Connector$new(extra_class = NULL)

#### Arguments

- `extra_class`:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print method for a connector showing the registered methods and
specifications from the active bindings.

#### Usage

    Connector$print()

#### Returns

[invisible](https://rdrr.io/r/base/invisible.html) self.

------------------------------------------------------------------------

### Method [`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md)

List available content from the connector. See also
[list_content_cnt](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md).

#### Usage

    Connector$list_content_cnt(...)

#### Arguments

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

A [character](https://rdrr.io/r/base/character.html) vector of content
names

------------------------------------------------------------------------

### Method [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)

Read content from the connector. See also
[read_cnt](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md).

#### Usage

    Connector$read_cnt(name, ...)

#### Arguments

- `name`:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

R object with the content. For rectangular data a
[data.frame](https://rdrr.io/r/base/data.frame.html).

------------------------------------------------------------------------

### Method [`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md)

Write content to the connector.See also
[write_cnt](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md).

#### Usage

    Connector$write_cnt(x, name, ...)

#### Arguments

- `x`:

  The object to write to the connection

- `name`:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

[invisible](https://rdrr.io/r/base/invisible.html) self.

------------------------------------------------------------------------

### Method [`remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.md)

Remove or delete content from the connector. See also
[remove_cnt](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.md).

#### Usage

    Connector$remove_cnt(name, ...)

#### Arguments

- `name`:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

[invisible](https://rdrr.io/r/base/invisible.html) self.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Connector$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Create connector
cnt <- Connector$new()

cnt
#> <Connector>
#> Registered methods:
#> • `check_resource.Connector()`

# Standard error message if no method is implemented
cnt |>
  read_cnt("fake_data") |>
  try()
#> Error in method_error_msg(connector_object) : 
#>   Method not implemented for class <Connector/R6>
#> ℹ See the customize (`vignette(connector::customize)`) vignette on how to
#>   create custom connectors and methods

# Connection with extra class
cnt_my_class <- Connector$new(extra_class = "my_class")

cnt_my_class
#> <my_class/Connector>
#> Registered methods:
#> • `check_resource.Connector()`

# Custom method for the extra class
read_cnt.my_class <- function(connector_object) "Hello!"
registerS3method("read_cnt", "my_class", "read_cnt.my_class")

cnt_my_class
#> <my_class/Connector>
#> Registered methods:
#> • `read_cnt.my_class()`
#> • `check_resource.Connector()`

read_cnt(cnt_my_class)
#> [1] "Hello!"
```
