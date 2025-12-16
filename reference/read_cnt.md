# Read content from the connector

Generic implementing of how to read content from the different connector
objects:

- [ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md):
  Uses
  [`DBI::dbReadTable()`](https://dbi.r-dbi.org/reference/dbReadTable.html)
  to read the table from the DBI connection.

&nbsp;

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses
  [`read_file()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md)
  to read a given file. The underlying function used, and thereby also
  the arguments available through `...` depends on the file extension.

The file is located using internal function, which searches for files
matching the provided name. If multiple files match and no extension is
specified, it will use the default extension (configurable via
`options(connector.default_ext = "csv")`, defaults to "csv").

- [ConnectorLogger](https://novonordisk-opensource.github.io/connector/reference/ConnectorLogger.md):
  Logs the read operation and calls the underlying connector method.

## Usage

``` r
read_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDBI'
read_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorFS'
read_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorLogger'
read_cnt(connector_object, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

R object with the content. For rectangular data a
[data.frame](https://rdrr.io/r/base/data.frame.html).

## Examples

``` r
# Read table from DBI database
cnt <- connector_dbi(RSQLite::SQLite())

cnt |>
  write_cnt(iris, "iris")

cnt |>
  list_content_cnt()
#> [1] "iris"

cnt |>
  read_cnt("iris") |>
  head()
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa

# Write and read a CSV file using the file storage connector

folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)

cnt |>
  write_cnt(iris, "iris.csv")

cnt |>
  read_cnt("iris.csv") |>
  head()
#> Rows: 150 Columns: 5
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (1): Species
#> dbl (4): Sepal.Length, Sepal.Width, Petal.Length, Petal.Width
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> # A tibble: 6 × 5
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>          <dbl>       <dbl>        <dbl>       <dbl> <chr>  
#> 1          5.1         3.5          1.4         0.2 setosa 
#> 2          4.9         3            1.4         0.2 setosa 
#> 3          4.7         3.2          1.3         0.2 setosa 
#> 4          4.6         3.1          1.5         0.2 setosa 
#> 5          5           3.6          1.4         0.2 setosa 
#> 6          5.4         3.9          1.7         0.4 setosa 

# Add logging to a file system connector
folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connectors(data = connector_fs(folder)) |> add_logs()

cnt$data |>
  write_cnt(iris, "iris.csv")
#> {"time":"2025-12-16 14:14:56","type":"write","file":"iris.csv @ /tmp/RtmpDbHqZq/test1f175859e051"}

cnt$data |>
  read_cnt("iris.csv", show_col_types = FALSE) |>
  head()
#> {"time":"2025-12-16 14:14:56","type":"read","file":"iris.csv @ /tmp/RtmpDbHqZq/test1f175859e051"}
#> # A tibble: 6 × 5
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>          <dbl>       <dbl>        <dbl>       <dbl> <chr>  
#> 1          5.1         3.5          1.4         0.2 setosa 
#> 2          4.9         3            1.4         0.2 setosa 
#> 3          4.7         3.2          1.3         0.2 setosa 
#> 4          4.6         3.1          1.5         0.2 setosa 
#> 5          5           3.6          1.4         0.2 setosa 
#> 6          5.4         3.9          1.7         0.4 setosa 
```
