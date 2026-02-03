# Using connector without YAML files

``` r
library(connector)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

This vignette demonstrates how to create and use connector objects
programmatically in R code, without requiring YAML configuration files.
While YAML files are convenient for complex setups and reproducible
environments, sometimes you need the flexibility to create connectors
dynamically in your R scripts.

This approach is particularly useful when: - You need to create
connectors based on runtime conditions or user input - You’re working in
an interactive R session and want quick access to different storage
locations - You prefer defining your data connections directly in your
analysis code

## Creating Individual Connectors

You can create connector objects directly using the specific connector
functions:

### File System Connector

The
[`connector_fs()`](https://novonordisk-opensource.github.io/connector/reference/connector_fs.md)
function creates a connector for file-based storage. You specify the
directory path, and the connector handles reading and writing files in
various formats based on file extensions.

``` r
# Create a file system connector pointing to the 'data' directory
fs_conn <- connector_fs(path = "data")
fs_conn
#> <ConnectorFS>
#> Inherits from: <Connector>
#> Registered methods:
#> • `check_resource.ConnectorFS()`
#> • `create_directory_cnt.ConnectorFS()`
#> • `download_cnt.ConnectorFS()`
#> • `download_directory_cnt.ConnectorFS()`
#> • `list_content_cnt.ConnectorFS()`
#> • `log_read_connector.ConnectorFS()`
#> • `log_remove_connector.ConnectorFS()`
#> • `log_write_connector.ConnectorFS()`
#> • `read_cnt.ConnectorFS()`
#> • `remove_cnt.ConnectorFS()`
#> • `remove_directory_cnt.ConnectorFS()`
#> • `tbl_cnt.ConnectorFS()`
#> • `upload_cnt.ConnectorFS()`
#> • `upload_directory_cnt.ConnectorFS()`
#> • `write_cnt.ConnectorFS()`
#> Specifications:
#> • path: data
```

### Database Connector

The
[`connector_dbi()`](https://novonordisk-opensource.github.io/connector/reference/connector_dbi.md)
function creates a connector for database storage using the DBI
interface. This works with any DBI-compatible database driver (SQLite,
PostgreSQL, MySQL, etc.).

``` r
# Create a database connector using SQLite in-memory database
db_conn <- connector_dbi(
  drv = RSQLite::SQLite(),
  dbname = ":memory:"
)
db_conn
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
```

## Using Individual Connectors

Once you have a connector, you use the same functions regardless of
whether it’s a file system or database connector. This consistency makes
it easy to switch storage backends in your analysis.

``` r
# Write and read data using the file system connector
sample_data <- mtcars[1:5, 1:3]

# Write data - format is determined by file extension
fs_conn |> write_cnt(sample_data, "cars.csv")

# List all available content in this connector
fs_conn |> list_content_cnt()
#> [1] "cars.csv"

# Read the data back
retrieved_data <- fs_conn |> read_cnt("cars.csv")
#> Rows: 5 Columns: 3
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl (3): mpg, cyl, disp
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
head(retrieved_data)
#> # A tibble: 5 × 3
#>     mpg   cyl  disp
#>   <dbl> <dbl> <dbl>
#> 1  21       6   160
#> 2  21       6   160
#> 3  22.8     4   108
#> 4  21.4     6   258
#> 5  18.7     8   360
```

## Creating Multiple Connectors with `connectors()`

The
[`connectors()`](https://novonordisk-opensource.github.io/connector/reference/connectors.md)
function allows you to group multiple connector objects together with
meaningful names. This is useful for organizing different stages of your
data pipeline or different types of storage.

``` r
# Create a collection of connectors for different data stages
my_connectors <- connectors(
  staging = connector_fs(path = "staging"),
  analysis = connector_fs(path = "analysis")
)

my_connectors
#> <connector::connectors/list/S7_object>
#>   $staging <ConnectorFS>
#>   $analysis <ConnectorFS>
```

## Working with Multiple Connectors

With multiple connectors, you can organize your data workflow by using
different connectors for different purposes. Access each connector by
name using the `$` operator.

``` r
# Use different connectors for different stages of analysis
iris_sample <- iris[1:10, ]

# Store initial data in the staging area
my_connectors$staging |> write_cnt(iris_sample, "iris_raw.rds")

# Process the data
processed <- iris_sample |>
  group_by(Species) |>
  summarise(mean_length = mean(Sepal.Length))

# Store the analysis results
my_connectors$analysis |> write_cnt(processed, "iris_summary.csv")

# Check contents of each connector
my_connectors$staging |> list_content_cnt()
#> [1] "iris_raw.rds"
my_connectors$analysis |> list_content_cnt()
#> [1] "iris_summary.csv"
```

## Mixed Storage Types

One of the powerful features of the connector package is the ability to
combine different storage types (files and databases) with the same
interface. This lets you choose the best storage method for each type of
data.

``` r
# Mix file system and database connectors in one collection
mixed_connectors <- connectors(
  files = connector_fs(path = "output"),
  database = connector_dbi(RSQLite::SQLite(), dbname = ":memory:")
)

# Store the same data in different formats
test_data <- data.frame(x = 1:3, y = letters[1:3])

# Save as CSV file
mixed_connectors$files |> write_cnt(test_data, "test.csv")

# Save as database table
mixed_connectors$database |> write_cnt(test_data, "test_table")

# List contents from both storage types using the same function
mixed_connectors$files |> list_content_cnt()
#> [1] "test.csv"
mixed_connectors$database |> list_content_cnt()
#> [1] "test_table"
```

## Summary

Creating connectors programmatically in R gives you the flexibility to:

- Use
  [`connector_fs()`](https://novonordisk-opensource.github.io/connector/reference/connector_fs.md)
  and
  [`connector_dbi()`](https://novonordisk-opensource.github.io/connector/reference/connector_dbi.md)
  to create individual connectors for different storage types
- Use
  [`connectors()`](https://novonordisk-opensource.github.io/connector/reference/connectors.md)
  to group multiple connectors with meaningful names
- Access individual connectors by name: `my_connectors$name`
- Switch between storage backends while using the same functions:
  [`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md),
  [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md),
  [`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md),
  [`remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.md)

This approach provides the same organized, consistent interface as
YAML-based configuration while giving you the ability to create
connectors dynamically based on your analysis needs.
