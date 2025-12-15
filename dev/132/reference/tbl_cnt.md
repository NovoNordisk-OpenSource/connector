# Use dplyr verbs to interact with the remote database table

Generic implementing of how to create a
[`dplyr::tbl()`](https://dplyr.tidyverse.org/reference/tbl.html)
connection in order to use dplyr verbs to interact with the remote
database table. Mostly relevant for DBI connectors.

- [ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md):
  Uses [`dplyr::tbl()`](https://dplyr.tidyverse.org/reference/tbl.html)
  to create a table reference to a table in a DBI connection.

&nbsp;

- [ConnectorFS](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md):
  Uses
  [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
  to allow redundancy between fs and dbi.

## Usage

``` r
tbl_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDBI'
tbl_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorFS'
tbl_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorLogger'
tbl_cnt(connector_object, name, ...)
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

A [dplyr::tbl](https://dplyr.tidyverse.org/reference/tbl.html) object.

## Examples

``` r
# Use dplyr verbs on a table in a DBI database
cnt <- connector_dbi(RSQLite::SQLite())

iris_cnt <- cnt |>
  write_cnt(iris, "iris") |>
  tbl_cnt("iris")

iris_cnt
#> # Source:   table<`iris`> [?? x 5]
#> # Database: sqlite 3.51.1 []
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>  
#>  1          5.1         3.5          1.4         0.2 setosa 
#>  2          4.9         3            1.4         0.2 setosa 
#>  3          4.7         3.2          1.3         0.2 setosa 
#>  4          4.6         3.1          1.5         0.2 setosa 
#>  5          5           3.6          1.4         0.2 setosa 
#>  6          5.4         3.9          1.7         0.4 setosa 
#>  7          4.6         3.4          1.4         0.3 setosa 
#>  8          5           3.4          1.5         0.2 setosa 
#>  9          4.4         2.9          1.4         0.2 setosa 
#> 10          4.9         3.1          1.5         0.1 setosa 
#> # ℹ more rows

iris_cnt |>
  dplyr::collect()
#> # A tibble: 150 × 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>  
#>  1          5.1         3.5          1.4         0.2 setosa 
#>  2          4.9         3            1.4         0.2 setosa 
#>  3          4.7         3.2          1.3         0.2 setosa 
#>  4          4.6         3.1          1.5         0.2 setosa 
#>  5          5           3.6          1.4         0.2 setosa 
#>  6          5.4         3.9          1.7         0.4 setosa 
#>  7          4.6         3.4          1.4         0.3 setosa 
#>  8          5           3.4          1.5         0.2 setosa 
#>  9          4.4         2.9          1.4         0.2 setosa 
#> 10          4.9         3.1          1.5         0.1 setosa 
#> # ℹ 140 more rows

iris_cnt |>
  dplyr::group_by(Species) |>
  dplyr::summarise(
    n = dplyr::n(),
    mean.Sepal.Length = mean(Sepal.Length, na.rm = TRUE)
  ) |>
  dplyr::collect()
#> # A tibble: 3 × 3
#>   Species        n mean.Sepal.Length
#>   <chr>      <int>             <dbl>
#> 1 setosa        50              5.01
#> 2 versicolor    50              5.94
#> 3 virginica     50              6.59

# Use dplyr verbs on a table

folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)

cnt <- connector_fs(folder)

cnt |>
  write_cnt(iris, "iris.csv")

iris_cnt <- cnt |>
  tbl_cnt("iris.csv", show_col_types = FALSE)
#> → Found one file: /tmp/Rtmptz0BAX/test1ee76884b148/iris.csv

iris_cnt
#> # A tibble: 150 × 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>  
#>  1          5.1         3.5          1.4         0.2 setosa 
#>  2          4.9         3            1.4         0.2 setosa 
#>  3          4.7         3.2          1.3         0.2 setosa 
#>  4          4.6         3.1          1.5         0.2 setosa 
#>  5          5           3.6          1.4         0.2 setosa 
#>  6          5.4         3.9          1.7         0.4 setosa 
#>  7          4.6         3.4          1.4         0.3 setosa 
#>  8          5           3.4          1.5         0.2 setosa 
#>  9          4.4         2.9          1.4         0.2 setosa 
#> 10          4.9         3.1          1.5         0.1 setosa 
#> # ℹ 140 more rows

iris_cnt |>
  dplyr::group_by(Species) |>
  dplyr::summarise(
    n = dplyr::n(),
    mean.Sepal.Length = mean(Sepal.Length, na.rm = TRUE)
  )
#> # A tibble: 3 × 3
#>   Species        n mean.Sepal.Length
#>   <chr>      <int>             <dbl>
#> 1 setosa        50              5.01
#> 2 versicolor    50              5.94
#> 3 virginica     50              6.59
```
