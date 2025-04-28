
# connector <a href="https://novonordisk-opensource.github.io/connector/"><img src="man/figures/logo.png" align="right" height="138" alt="connector website" /></a>

<!-- badges: start -->

[![Checks](https://github.com/NovoNordisk-OpenSource/connector/actions/workflows/check_and_co.yaml/badge.svg)](https://github.com/NovoNordisk-OpenSource/connector/actions/workflows/check_and_co.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/connector)](https://CRAN.R-project.org/package=connector)
<!-- badges: end -->

## Installation

``` r
# Install the released version from CRAN:
install.packages("connector")
# Install the development version from GitHub:
pak::pak("NovoNordisk-OpenSource/connector")
```

## Overview

`connector` provides a seamless and consistent interface for connecting
to different data sources, such as as simple file storage systems and
databases.

It also gives the option to use a central configuration file to manage
your connections in your project, which ensures a consistent reference
to the same data source across different scripts in your project, and
enables you to easily switch between different data sources.

The connector package comes with the possibilities of creating
connections to file system folders using `connector_fs` and general
databases using `connector_dbi`, which is built on top of the `{DBI}`
package.

connector also has a series of expansion packages that allows you to
easily connect to more specific data sources:

- `{connector.databricks}`: Connect to Databricks
- `{connector.sharepoint}`: Connect to SharePoint sites

## Usage

The recommended way of using connector is to specify a common yaml
configuration file in your project that contains the connection details
to all your data sources.

A simple example creating connectors to both a folder and a database is
shown below:

`_connector.yml:`

``` yaml
metadata:
  path: !expr withr::local_tempdir()

datasources:
  - name: "folder"
    backend:
        type: "connector::connector_fs"
        path: "{metadata.path}"
  - name: "database"
    backend:
        type: "connector::connector_dbi"
        drv: "RSQLite::SQLite()"
        dbname: ":memory:"
```

First we specify common metadata for the connectors, which here is a
temporary folder that we want to use. Afterwards we specify the
datasources needed in the project, and their specifications.

The first we name “folder”, specify the type to be `connector_fs()`, and
the path to the folder. The second is a database connector to an in
memory SQLite database, that we specify using the `connector_dbi()`
type, which uses `DBI::dbConnect()` to initalize the connection.
Therefor we also give the `DBI driver` to use, and arguments to it.

To connect and create the conenctors we use `connect()` with the
configuration file as input:

``` r
library(connector)

db <- connect("_connector.yml")
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → folder
#> • connector::connector_fs
#> • /var/folders/fx/71by3f551qzb5wkxt82cv15m0000gp/T//RtmpYpGBoY/file49e7314de81d
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → database
#> • connector::connector_dbi
#> • RSQLite::SQLite() and :memory:

print(db)
#> <connectors>
#>   $folder <ConnectorFS>
#>   $database <ConnectorDBI>
```

This creates a `connectors` objects that contains each `connector`. When
printing the individual `connector` you get the some general information
on their methods and specifications.

``` r
print(db$database)
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
#> Specifications:
#> • conn: <SQLiteConnection>
```

We are now ready to use the `connectors`, so we can start by writing
some data to the `folder` one:

``` r
# Initially it is empty
db$folder |>
  list_content_cnt()
#> character(0)

# Create some data
cars <- mtcars |>
  tibble::as_tibble(rownames = "car")

# Write to folder as a parquet file
db$folder |>
  write_cnt(x = cars, name = "cars.parquet")

# Now the folder contains the file
db$folder |>
  list_content_cnt()
#> [1] "cars.parquet"

# And we can read it back in
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

Here the parquet format has been used, but when using a `connector_fs`
it is possible to read and write several different file types. See
`read_file()` and `write_file()` for more information.

For the `database` connector it works in the same way:

``` r
# Initially no tables exists
db$database |>
  list_content_cnt()
#> character(0)

# Write cars to the database as a table
db$database |>
  write_cnt(x = cars, name = "cars")

# Now the cara table exists
db$database |>
  list_content_cnt()
#> [1] "cars"

# And we can read it back in
db$database |>
  read_cnt(name = "cars") |>
  dplyr::as_tibble()
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

## Useful links

For more information on how to use the package, see the following links:

- `connect()` for more documentation and how to specify the
  configuration file
- `vignette("connector")` for more examples and how to use the package
- `vignette("customize")` on how to create your own connector and
  customize behavior
- [NovoNordisk-OpenSource/R-packages](https://novonordisk-opensource.github.io/R-packages/)
  for an overview of connector and other R packages published by Novo
  Nordisk
