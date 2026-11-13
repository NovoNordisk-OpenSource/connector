# Connector for DBI databases

Connector object for DBI connections. This object is used to interact
with DBI compliant database backends. See the [DBI
package](https://dbi.r-dbi.org/) for which backends are supported.

## Details

We recommend using the wrapper function
[`connector_dbi()`](https://novonordisk-opensource.github.io/connector/reference/connector_dbi.md)
to simplify the process of creating an object of ConnectorDBI class. It
provides a more intuitive and user-friendly approach to initialize the
ConnectorFS class and its associated functionalities.

Upon garbage collection, the connection will try to disconnect from the
database. But it is good practice to call
[disconnect_cnt](https://novonordisk-opensource.github.io/connector/reference/disconnect_cnt.md)
when you are done with the connection.

## Super class

[`connector::Connector`](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
-\> `ConnectorDBI`

## Active bindings

- `conn`:

  The DBI connection. Inherits from
  [DBI::DBIConnector](https://dbi.r-dbi.org/reference/DBIConnector-class.html)

## Methods

### Public methods

- [`ConnectorDBI$new()`](#method-ConnectorDBI-new)

- [`ConnectorDBI$disconnect_cnt()`](#method-ConnectorDBI-disconnect_cnt)

- [`ConnectorDBI$tbl_cnt()`](#method-ConnectorDBI-tbl_cnt)

- [`ConnectorDBI$clone()`](#method-ConnectorDBI-clone)

Inherited methods

- [`connector::Connector$list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-list_content_cnt)
- [`connector::Connector$print()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-print)
- [`connector::Connector$read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-read_cnt)
- [`connector::Connector$remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-remove_cnt)
- [`connector::Connector$write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-write_cnt)

------------------------------------------------------------------------

### Method `new()`

Initialize the connection

#### Usage

    ConnectorDBI$new(drv, ..., extra_class = NULL)

#### Arguments

- `drv`:

  Driver object inheriting from
  [DBI::DBIDriver](https://dbi.r-dbi.org/reference/DBIDriver-class.html).

- `...`:

  Additional arguments passed to
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).

- `extra_class`:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector.

------------------------------------------------------------------------

### Method [`disconnect_cnt()`](https://novonordisk-opensource.github.io/connector/reference/disconnect_cnt.md)

Disconnect from the database. See also
[disconnect_cnt](https://novonordisk-opensource.github.io/connector/reference/disconnect_cnt.md).

#### Usage

    ConnectorDBI$disconnect_cnt()

#### Returns

[invisible](https://rdrr.io/r/base/invisible.html) `self`.

------------------------------------------------------------------------

### Method [`tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.md)

Use dplyr verbs to interact with the remote database table. See also
[tbl_cnt](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.md).

#### Usage

    ConnectorDBI$tbl_cnt(name, ...)

#### Arguments

- `name`:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

A [dplyr::tbl](https://dplyr.tidyverse.org/reference/tbl.html) object.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ConnectorDBI$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Create DBI connector
cnt <- ConnectorDBI$new(RSQLite::SQLite(), ":memory:")
cnt
#> <ConnectorDBI>
#> Inherits from: <Connector>
#> Registered methods:
#> • `disconnect_cnt.ConnectorDBI()`
#> • `list_content_cnt.ConnectorDBI()`
#> • `log_read_connector.ConnectorDBI()`
#> • `log_remove_connector.ConnectorDBI()`
#> • `log_write_connector.ConnectorDBI()`
#> • `read_cnt.ConnectorDBI()`
#> • `remove_cnt.ConnectorDBI()`
#> • `tbl_cnt.ConnectorDBI()`
#> • `write_cnt.ConnectorDBI()`
#> • `check_resource.Connector()`
#> Specifications:
#> • conn: <SQLiteConnection>

# You can do the same thing using wrapper function connector_dbi()
cnt <- connector_dbi(RSQLite::SQLite(), ":memory:")
cnt
#> <ConnectorDBI>
#> Inherits from: <Connector>
#> Registered methods:
#> • `disconnect_cnt.ConnectorDBI()`
#> • `list_content_cnt.ConnectorDBI()`
#> • `log_read_connector.ConnectorDBI()`
#> • `log_remove_connector.ConnectorDBI()`
#> • `log_write_connector.ConnectorDBI()`
#> • `read_cnt.ConnectorDBI()`
#> • `remove_cnt.ConnectorDBI()`
#> • `tbl_cnt.ConnectorDBI()`
#> • `write_cnt.ConnectorDBI()`
#> • `check_resource.Connector()`
#> Specifications:
#> • conn: <SQLiteConnection>
# Write to the database
cnt$write_cnt(iris, "iris")

# Read from the database
cnt$read_cnt("iris") |>
  head()
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa

# List available tables
cnt$list_content_cnt()
#> [1] "iris"

# Use the connector to run a query
cnt$conn
#> <SQLiteConnection>
#>   Path: :memory:
#>   Extensions: TRUE

cnt$conn |>
  DBI::dbGetQuery("SELECT * FROM iris limit 5")
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa

# Use dplyr verbs and collect data
cnt$tbl_cnt("iris") |>
  dplyr::filter(Sepal.Length > 7) |>
  dplyr::collect()
#> # A tibble: 12 × 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species  
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>    
#>  1          7.1         3            5.9         2.1 virginica
#>  2          7.6         3            6.6         2.1 virginica
#>  3          7.3         2.9          6.3         1.8 virginica
#>  4          7.2         3.6          6.1         2.5 virginica
#>  5          7.7         3.8          6.7         2.2 virginica
#>  6          7.7         2.6          6.9         2.3 virginica
#>  7          7.7         2.8          6.7         2   virginica
#>  8          7.2         3.2          6           1.8 virginica
#>  9          7.2         3            5.8         1.6 virginica
#> 10          7.4         2.8          6.1         1.9 virginica
#> 11          7.9         3.8          6.4         2   virginica
#> 12          7.7         3            6.1         2.3 virginica

# Disconnect from the database
cnt$disconnect_cnt()
```
