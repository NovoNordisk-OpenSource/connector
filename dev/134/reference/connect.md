# Connect to datasources specified in a config file

Based on a configuration file or list this functions creates a
[`connectors()`](https://novonordisk-opensource.github.io/connector/reference/connectors.md)
object with a
[Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
for each of the specified datasources.

The configuration file can be in any format that can be read through
[`read_file()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md),
and contains a list. If a yaml file is provided, expressions are
evaluated when parsing it using
[`yaml::read_yaml()`](https://yaml.r-lib.org/reference/read_yaml.html)
with `eval.expr = TRUE`.

See also
[`vignette("connector")`](https://novonordisk-opensource.github.io/connector/articles/connector.md)
on how to use configuration files in your project, details below for the
required structure of the configuration.

## Usage

``` r
connect(
  config = "_connector.yml",
  metadata = NULL,
  datasource = NULL,
  set_env = TRUE,
  logging = zephyr::get_option("logging", "connector")
)
```

## Arguments

- config:

  [character](https://rdrr.io/r/base/character.html) path to a connector
  config file or a [list](https://rdrr.io/r/base/list.html) of
  specifications

- metadata:

  [list](https://rdrr.io/r/base/list.html) Replace, add or create
  elements to the metadata field found in config

- datasource:

  [character](https://rdrr.io/r/base/character.html) Name(s) of the
  datasource(s) to connect to. If `NULL` (the default) all datasources
  are connected.

- set_env:

  [logical](https://rdrr.io/r/base/logical.html) Should environment
  variables from the yaml file be set? Default is `TRUE`.

- logging:

  Add logging capability to connectors using
  [`add_logs()`](https://novonordisk-opensource.github.io/connector/reference/add_logs.md).
  When `TRUE`, all connector operations will be logged to the console
  and to whirl log HTML files. See
  [log-functions](https://novonordisk-opensource.github.io/connector/reference/log-functions.md)
  for available logging functions.. Default: `FALSE`.

## Value

[connectors](https://novonordisk-opensource.github.io/connector/reference/connectors.md)

## Details

The input list can be specified in two ways:

1.  A named list containing the specifications of a single
    [connectors](https://novonordisk-opensource.github.io/connector/reference/connectors.md)
    object.

2.  An unnamed list, where each element is of the same structure as in
    1., which returns a nested
    [connectors](https://novonordisk-opensource.github.io/connector/reference/connectors.md)
    object. See example below.

Each specification of a single
[connectors](https://novonordisk-opensource.github.io/connector/reference/connectors.md)
have to have the following structure:

- Only name, metadata, env and datasources are allowed.

- All elements must be named.

- **name** is only required when using nested connectors.

- **datasources** is mandatory.

- **metadata** and **env** must each be a list of named character
  vectors of length 1 if specified.

- **datasources** must each be a list of unnamed lists.

- Each datasource must have the named character element **name** and the
  named list element **backend**

- For each connection **backend**.**type** must be provided

## Examples

``` r
withr::local_dir(withr::local_tempdir("test", .local_envir = .GlobalEnv))
# Create dir for the example in tmpdir
dir.create("example/demo_trial/adam", recursive = TRUE)

# Create a config file in the example folder
config <- system.file("config", "_connector.yml", package = "connector")

# Show the raw configuration file
readLines(config) |>
  cat(sep = "\n")
#> # A example of the configuration file for FS and Database
#> metadata:
#>   trial: "demo_trial"
#>   root_path: "example"
#>   extra_class: "test2"
#> 
#> datasources:
#>   - name: "adam"
#>     backend:
#>         type: "connector_fs"
#>         path: "{metadata.root_path}/{metadata.trial}/adam"
#>         extra_class: "{metadata.extra_class}"
#>   - name: "sdtm"
#>     backend:
#>         type: "connector_dbi"
#>         drv: "RSQLite::SQLite()"
#>         dbname: ":memory:"

# Connect to the datasources specified in it
cnts <- connect(config)
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → adam
#> • connector_fs
#> • example/demo_trial/adam and test2
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → sdtm
#> • connector_dbi
#> • RSQLite::SQLite() and :memory:
cnts
#> <connectors>
#>   $adam <test2>
#>   $sdtm <ConnectorDBI>
#>   
#>   Metadata:
#>   → trial: "demo_trial"
#>   → root_path: "example"
#>   → extra_class: "test2"

# Content of each connector

cnts$adam
#> <test2/ConnectorFS>
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
#> • path: example/demo_trial/adam
#> • metadata: <list>
cnts$sdtm
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

# Overwrite metadata informations

connect(config, metadata = list(extra_class = "my_class"))
#> ℹ Replace some metadata informations...
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → adam
#> • connector_fs
#> • example/demo_trial/adam and my_class
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → sdtm
#> • connector_dbi
#> • RSQLite::SQLite() and :memory:
#> <connectors>
#>   $adam <my_class>
#>   $sdtm <ConnectorDBI>
#>   
#>   Metadata:
#>   → trial: "demo_trial"
#>   → root_path: "example"
#>   → extra_class: "my_class"

# Connect only to the adam datasource

connect(config, datasource = "adam")
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → adam
#> • connector_fs
#> • example/demo_trial/adam and test2
#> <connectors>
#>   $adam <test2>
#>   
#>   Metadata:
#>   → trial: "demo_trial"
#>   → root_path: "example"
#>   → extra_class: "test2"

# Connect to several projects in a nested structure

config_nested <- system.file("config", "_nested_connector.yml", package = "connector")

readLines(config_nested) |>
  cat(sep = "\n")
#> # A example of the configuration file nested connectors
#> - name: "study1"
#>   metadata:
#>     trial: "demo_trial"
#>     root_path: "example"
#>   datasources:
#>     - name: "adam_fs"
#>       backend:
#>           type: "connector_fs"
#>           path: "{metadata.root_path}/{metadata.trial}/adam"
#> 
#> - name: "study2"
#>   metadata:
#>     trial: "demo_trial"
#>     root_path: "example"
#>   datasources:
#>     - name: "adam_fs"
#>       backend:
#>           type: "connector_fs"
#>           path: "{metadata.root_path}/{metadata.trial}/adam"

cnts_nested <- connect(config_nested)
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → adam_fs
#> • connector_fs
#> • example/demo_trial/adam
#> ────────────────────────────────────────────────────────────────────────────────
#> Connection to:
#> → adam_fs
#> • connector_fs
#> • example/demo_trial/adam

cnts_nested
#> <nested_connectors>
#>   $study1 <connectors>
#>   $study2 <connectors>

cnts_nested$study1
#> <connectors>
#>   $adam_fs <ConnectorFS>
#>   
#>   Metadata:
#>   → trial: "demo_trial"
#>   → root_path: "example"

withr::deferred_run()
#> No deferred expressions to run
```
