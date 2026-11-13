# Write files based on the extension

`write_file()` is the backbone of all
[`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md)
methods, where files are written to a connector. The function is a
wrapper around `write_ext()` where the appropriate function to write the
file is chosen depending on the file extension.

`write_ext()` has methods defined for the following file extensions:

- `txt`:
  [`readr::write_lines()`](https://readr.tidyverse.org/reference/read_lines.html)

&nbsp;

- `csv`:
  [`readr::write_csv()`](https://readr.tidyverse.org/reference/write_delim.html)

&nbsp;

- `parquet`:
  [`arrow::write_parquet()`](https://arrow.apache.org/docs/r/reference/write_parquet.html)

&nbsp;

- `rds`:
  [`readr::write_rds()`](https://readr.tidyverse.org/reference/read_rds.html)

&nbsp;

- `xpt`:
  [`haven::write_xpt()`](https://haven.tidyverse.org/reference/read_xpt.html)

&nbsp;

- `yml`/`yaml`:
  [`yaml::write_yaml()`](https://yaml.r-lib.org/reference/write_yaml.html)

&nbsp;

- `json`:
  [`jsonlite::write_json()`](https://jeroen.r-universe.dev/jsonlite/reference/read_json.html)

&nbsp;

- `excel`:
  [`writexl::write_xlsx()`](https://docs.ropensci.org/writexl//reference/write_xlsx.html)

## Usage

``` r
write_file(x, file, overwrite = FALSE, ...)

write_ext(file, x, ...)

# S3 method for class 'txt'
write_ext(file, x, ...)

# S3 method for class 'csv'
write_ext(file, x, delim = ",", ...)

# S3 method for class 'parquet'
write_ext(file, x, ...)

# S3 method for class 'rds'
write_ext(file, x, ...)

# S3 method for class 'xpt'
write_ext(file, x, ...)

# S3 method for class 'yml'
write_ext(file, x, ...)

# S3 method for class 'json'
write_ext(file, x, ...)

# S3 method for class 'xlsx'
write_ext(file, x, ...)
```

## Arguments

- x:

  Object to write

- file:

  [`character()`](https://rdrr.io/r/base/character.html) Path to write
  the file.

- overwrite:

  [logical](https://rdrr.io/r/base/logical.html) Overwrite existing
  content if it exists.

- ...:

  Other parameters passed on the functions behind the methods for each
  file extension.

- delim:

  [`character()`](https://rdrr.io/r/base/character.html) Delimiter to
  use. Default is `","`.

## Value

`write_file()`: [`invisible()`](https://rdrr.io/r/base/invisible.html)
file.

`write_ext()`: The return of the functions behind the individual
methods.

## Details

Note that `write_file()` will not overwrite existing files unless
`overwrite = TRUE`, while all methods for `write_ext()` will overwrite
existing files by default.

## Examples

``` r
# Write CSV file
temp_csv <- tempfile("iris", fileext = ".csv")
write_file(iris, temp_csv)
```
