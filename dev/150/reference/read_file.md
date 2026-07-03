# Read files based on the extension

`read_file()` is the backbone of all
[read_cnt](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
methods, where files are read from their source. The function is a
wrapper around `read_ext()`, that controls the dispatch based on the
file extension.

`read_ext()` controls which packages and functions are used to read the
individual file extensions. Below is a list of all the pre-defined
methods:

- `default`: All extensions not listed below is attempted to be read
  with
  [`vroom::vroom()`](https://vroom.tidyverse.org/reference/vroom.html)

&nbsp;

- `txt`:
  [`readr::read_lines()`](https://readr.tidyverse.org/reference/read_lines.html)

&nbsp;

- `csv`:
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)

&nbsp;

- `parquet`:
  [`arrow::read_parquet()`](https://arrow.apache.org/docs/r/reference/read_parquet.html)

&nbsp;

- `rds`:
  [`readr::read_rds()`](https://readr.tidyverse.org/reference/read_rds.html)

&nbsp;

- `sas7bdat`:
  [`haven::read_sas()`](https://haven.tidyverse.org/reference/read_sas.html)

&nbsp;

- `xpt`:
  [`haven::read_xpt()`](https://haven.tidyverse.org/reference/read_xpt.html)

&nbsp;

- `yml`/`yaml`:
  [`yaml::read_yaml()`](https://yaml.r-lib.org/reference/read_yaml.html)

&nbsp;

- `json`:
  [`jsonlite::read_json()`](https://jeroen.r-universe.dev/jsonlite/reference/read_json.html)

&nbsp;

- `excel`:
  [`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html)

## Usage

``` r
read_file(path, ...)

read_ext(path, ...)

# Default S3 method
read_ext(path, ...)

# S3 method for class 'txt'
read_ext(path, ...)

# S3 method for class 'csv'
read_ext(path, delim = ",", ...)

# S3 method for class 'parquet'
read_ext(path, ...)

# S3 method for class 'rds'
read_ext(path, ...)

# S3 method for class 'sas7bdat'
read_ext(path, ...)

# S3 method for class 'xpt'
read_ext(path, ...)

# S3 method for class 'yml'
read_ext(path, ...)

# S3 method for class 'json'
read_ext(path, ...)

# S3 method for class 'xlsx'
read_ext(path, ...)
```

## Arguments

- path:

  [`character()`](https://rdrr.io/r/base/character.html) Path to the
  file.

- ...:

  Other parameters passed on the functions behind the methods for each
  file extension.

- delim:

  Single character used to separate fields within a record.

## Value

the result of the reading function

## Examples

``` r
# Read CSV file
temp_csv <- tempfile("iris", fileext = ".csv")
write.csv(iris, temp_csv, row.names = FALSE)
# Read the CSV file using read_ext.csv
read_file(temp_csv, show_col_types = FALSE)
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
```
