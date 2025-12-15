# connector

## Introduction

The `connector` package provides a set of functions to connect to
different data sources (such as databases and file systems) and read and
write data from them using a consistent interface.

It is designed to be a generic and extensible package, so that new data
sources can be added easily.

This vignette demonstrates how to use the `connector` package to connect
to either a **file system** or a **database** to access different types
of data.

## Connector configuration

The main function in this package is
[`connect()`](https://novonordisk-opensource.github.io/connector/reference/connect.md).
This function, based on a configuration file or a list, creates a
`connectors` object with a `connector` for each of the specified data
sources. The configuration file can be in list format, JSON, or YAML
format.

The input list (or configuration file) must have the following
structure:

- Only `metadata`, `env`, and `datasources` fields are allowed.
- All elements must be named.
- **`datasources`** is mandatory.
- **`metadata`** and **`env`** must each be a list of named character
  vectors of length 1.
- **`datasources`** must be a list of unnamed lists.
- Each datasource must have the named character element **`name`** and
  the named list element **`backend`**.
- For each backend, **`type`** must be provided.

## Working example

Here is an example anyone can run to see how the `connector` package
works. We will use the configuration file provided below, which uses the
file system as the connection type for ADaM and TFL data.

`_connector.yml:`

``` yaml
metadata:
  adam_path: !expr file.path(getwd(), "adam")
  tfl_path: !expr file.path(getwd(), "tfl")

datasources:
  - name: "adam"
    backend:
      type: "connector::connector_fs"
      path: "{metadata.adam_path}"
  - name: "tfl"
    backend:
      type: "connector::connector_fs"
      path: "{metadata.tfl_path}"
```

As you can see, the configuration file contains metadata about the paths
to the directories where the data will be stored, and two data sources:
`adam` and `tfl`, both using the `connector_fs` backend to connect to
file system folders. Note that the paths to the directories are defined
using metadata variables (e.g., `{metadata.adam_path}`), which allows
you to easily change the paths in one place.

Now, let’s run the example:

The first step is to create the connections to the data sources.

``` r
# Load data connections
db <- connect()
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → adam
#> • connector::connector_fs
#> • /tmp/RtmpDUHdOH/file292f461997da/adam
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → tfl
#> • connector::connector_fs
#> • /tmp/RtmpDUHdOH/file292f461997da/tfl
```

Next, we manipulate the iris dataset and store it in the `adam`
connector. This means we will create a subset of the iris dataset and
save it as an RDS file in the `adam` directory.

``` r
## Iris data
setosa <- iris |>
  filter(Species == "setosa")
## Store data
db$adam |>
  write_cnt(setosa, "setosa.rds")
```

We can also create more complex summaries and store them in the same
connector.

``` r
mean_for_all_iris <- iris |>
  group_by(Species) |>
  summarise_all(list(mean, median, sd, min, max))

db$adam |>
  write_cnt(mean_for_all_iris, "mean_iris.rds")

## List and load data
db$adam |>
  list_content_cnt()
#> [1] "mean_iris.rds" "setosa.rds"
```

We can also read back the data we just created and filter it further
using the
[`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
function.

``` r
# Read and filter data
setosa_filtered <- db$adam |>
  read_cnt("setosa") |>
  filter(Sepal.Length > 5)
#> → Found one file: /tmp/RtmpDUHdOH/file292f461997da/adam/setosa.rds
```

Finally, we can create a plot with the `ggplot2` package and store it in
the `tfl` connector.

``` r
# Create a plot
plot_setosa <- ggplot(setosa_filtered) +
  aes(x = Sepal.Length, y = Sepal.Width) +
  geom_point()

## Store data and plot objects
db$tfl |>
  write_cnt(plot_setosa$data, "setosa_data.csv")
db$tfl |>
  write_cnt(plot_setosa, "setosa_plot.rds")

## Store plot image
tmp_file <- tempfile(fileext = ".png")
ggsave(tmp_file, plot_setosa)
#> Saving 7.29 x 4.51 in image
db$tfl |>
  upload_cnt(tmp_file, "setosa_plot.png")

# List all files in the TFL directory
db$tfl |>
  list_content_cnt()
#> [1] "setosa_data.csv" "setosa_plot.png" "setosa_plot.rds"
```
