# Connector Logging Functions

A comprehensive set of generic functions and methods for logging
connector operations. These functions provide automatic logging
capabilities for read, write, remove, and list operations across
different connector types, enabling transparent audit trails and
operation tracking.

## Usage

``` r
log_read_connector(connector_object, name, ...)

# Default S3 method
log_read_connector(connector_object, name, ...)

log_write_connector(connector_object, name, ...)

# Default S3 method
log_write_connector(connector_object, name, ...)

log_remove_connector(connector_object, name, ...)

# Default S3 method
log_remove_connector(connector_object, name, ...)

log_list_content_connector(connector_object, ...)

# S3 method for class 'ConnectorDBI'
log_read_connector(connector_object, name, ...)

# S3 method for class 'ConnectorDBI'
log_write_connector(connector_object, name, ...)

# S3 method for class 'ConnectorDBI'
log_remove_connector(connector_object, name, ...)

# S3 method for class 'ConnectorFS'
log_read_connector(connector_object, name, ...)

# S3 method for class 'ConnectorFS'
log_write_connector(connector_object, name, ...)

# S3 method for class 'ConnectorFS'
log_remove_connector(connector_object, name, ...)
```

## Arguments

- connector_object:

  The connector object to log operations for. Can be any connector class
  (ConnectorFS, ConnectorDBI, ConnectorLogger, etc.)

- name:

  Character string specifying the name or identifier of the resource
  being operated on (e.g., file name, table name)

- ...:

  Additional parameters passed to specific method implementations. May
  include connector-specific options or metadata.

## Value

These are primarily side-effect functions that perform logging. The
actual return value depends on the specific method implementation,
typically:

- `log_read_connector`: Result of the read operation

- `log_write_connector`: Invisible result of write operation

- `log_remove_connector`: Invisible result of remove operation

- `log_list_content_connector`: List of connector contents

## Details

Connector Logging Functions

The logging system is built around S3 generic functions that dispatch to
specific implementations based on the connector class. Each operation is
logged with contextual information including connector details,
operation type, and resource names.

## Available Operations

- `log_read_connector(connector_object, name, ...)`:

  Logs read operations when data is retrieved from a connector.
  Automatically called by
  [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
  and
  [`tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.md)
  methods.

- `log_write_connector(connector_object, name, ...)`:

  Logs write operations when data is stored to a connector.
  Automatically called by
  [`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md)
  and
  [`upload_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_cnt.md)
  methods.

- `log_remove_connector(connector_object, name, ...)`:

  Logs removal operations when resources are deleted from a connector.
  Automatically called by
  [`remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.md)
  methods.

- `log_list_content_connector(connector_object, ...)`:

  Logs listing operations when connector contents are queried.
  Automatically called by
  [`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md)
  methods.

## Supported Connector Types

Each connector type has specialized logging implementations:

- **ConnectorFS**:

  File system connectors log the full file path and operation type.
  Example log: `"dataset.csv @ /path/to/data"`

- **ConnectorDBI**:

  Database connectors log driver information and database name. Example
  log: `"table_name @ driver: SQLiteDriver, dbname: mydb.sqlite"`

## Integration with whirl Package

All logging operations use the whirl package for consistent log output:

- [`whirl::log_read()`](https://novonordisk-opensource.github.io/whirl/reference/custom_logging.html) -
  For read operations

- [`whirl::log_write()`](https://novonordisk-opensource.github.io/whirl/reference/custom_logging.html) -
  For write operations

- [`whirl::log_delete()`](https://novonordisk-opensource.github.io/whirl/reference/custom_logging.html) -
  For remove operations

## See also

[`add_logs`](https://novonordisk-opensource.github.io/connector/reference/add_logs.md)
for adding logging capability to connectors,
[`ConnectorLogger`](https://novonordisk-opensource.github.io/connector/reference/ConnectorLogger.md)
for the logger class, whirl package for underlying logging
implementation

## Examples

``` r
# Basic usage with file system connector
logged_fs <- add_logs(connectors(data = connector_fs(path = tempdir())))

# Write operation (automatically logged)
write_cnt(logged_fs$data, mtcars, "cars.csv")
#> {"time":"2026-02-02 12:07:16","type":"write","file":"cars.csv @ /tmp/RtmpH9kIBZ"}
# Output: "cars.csv @ /tmp/RtmpXXX"

#' # Read operation (automatically logged)
data <- read_cnt(logged_fs$data, "cars.csv")
#> Rows: 32 Columns: 11
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl (11): mpg, cyl, disp, hp, drat, wt, qsec, vs, am, gear, carb
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> {"time":"2026-02-02 12:07:16","type":"read","file":"cars.csv @ /tmp/RtmpH9kIBZ"}
# Output: "dataset.csv @ /tmp/RtmpXXX"

# Database connector example
logged_db <- add_logs(connectors(db = connector_dbi(RSQLite::SQLite(), ":memory:")))

# Operations are logged with database context
write_cnt(logged_db$db, iris, "iris_table")
#> {"time":"2026-02-02 12:07:16","type":"write","file":"iris_table @ driver: SQLiteConnection, dbname: :memory:"}
# Output: "iris_table @ driver: SQLiteDriver, dbname: :memory:"
```
