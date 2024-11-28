
# connector <a href="https://fantastic-adventure-gqozn9k.pages.github.io/"><img src="man/figures/logo.png" align="right" height="138" alt="connector website" /></a>

``` r
library(connector)
```

``` yml
metadata:
  path: !expr withr::local_tempdir()

datasources:
  - name: "folder"
    backend:
        type: "connector_fs"
        path: "{metadata.path}"
  - name: "database"
    backend:
        type: "connector_dbi"
        drv: "RSQLite::SQLite()"
        dbname: ":memory:"
```

``` r
config <- system.file("config/readme.yml", package = "connector")

db <- connect(config)
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → folder
#> • connector_fs
#> • /var/folders/fx/71by3f551qzb5wkxt82cv15m0000gp/T//RtmpvHQppu/file9d25600ee130
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → database
#> • connector_dbi
#> • RSQLite::SQLite() and :memory:

print(db)
#> <connectors>
#>   $folder <connector_fs>
#>   $database <connector_dbi>
```

``` r
db$folder
#> <connector_fs>
#> Inherits from: <connector>
#> Registered methods:
#> • `create_directory_cnt.connector_fs()`
#> • `download_cnt.connector_fs()`
#> • `list_content_cnt.connector_fs()`
#> • `read_cnt.connector_fs()`
#> • `remove_cnt.connector_fs()`
#> • `remove_directory_cnt.connector_fs()`
#> • `upload_cnt.connector_fs()`
#> • `write_cnt.connector_fs()`
#> Specifications:
#> • path:
#>   /var/folders/fx/71by3f551qzb5wkxt82cv15m0000gp/T//RtmpvHQppu/file9d25600ee130
db$database
#> <connector_dbi>
#> Inherits from: <connector>
#> Registered methods:
#> • `disconnect_cnt.connector_dbi()`
#> • `list_content_cnt.connector_dbi()`
#> • `read_cnt.connector_dbi()`
#> • `remove_cnt.connector_dbi()`
#> • `tbl_cnt.connector_dbi()`
#> • `write_cnt.connector_dbi()`
#> Specifications:
#> • conn: <SQLiteConnection>
```

``` r
db$folder |> 
  list_content_cnt()
#> character(0)

cars <- mtcars |> tibble::as_tibble(rownames = "car")

db$folder |> 
  write_cnt(x = cars, name = "cars.parquet")

db$folder |> 
  list_content_cnt()
#> [1] "cars.parquet"

db$folder |>
  read_cnt(name = "cars.parquet")
#> # A tibble: 32 × 12
#>    car           mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>    <chr>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 Mazda RX4    21       6  160    110  3.9   2.62  16.5     0     1     4     4
#>  2 Mazda RX4 …  21       6  160    110  3.9   2.88  17.0     0     1     4     4
#>  3 Datsun 710   22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
#>  4 Hornet 4 D…  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
#>  5 Hornet Spo…  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
#>  6 Valiant      18.1     6  225    105  2.76  3.46  20.2     1     0     3     1
#>  7 Duster 360   14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
#>  8 Merc 240D    24.4     4  147.    62  3.69  3.19  20       1     0     4     2
#>  9 Merc 230     22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
#> 10 Merc 280     19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4
#> # ℹ 22 more rows
```
