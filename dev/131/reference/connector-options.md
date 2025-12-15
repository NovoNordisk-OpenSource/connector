# Options for connector

### verbosity_level

Verbosity level for functions in connector. See
[zephyr::verbosity_level](https://novonordisk-opensource.github.io/zephyr/reference/verbosity_level.html)
for details.

- Default: `"verbose"`

- Option: `connector.verbosity_level`

- Environment: `R_CONNECTOR_VERBOSITY_LEVEL`

### overwrite

Overwrite existing content if it exists in the connector? See
connector-options for details. Default can be set globally with
`options(connector.overwrite = TRUE/FALSE)` or environment variable
`R_CONNECTOR_OVERWRITE`.

- Default: `FALSE`

- Option: `connector.overwrite`

- Environment: `R_CONNECTOR_OVERWRITE`

### logging

Add logging capability to connectors using
[`add_logs()`](https://novonordisk-opensource.github.io/connector/reference/add_logs.md).
When `TRUE`, all connector operations will be logged to the console and
to whirl log HTML files. See
[log-functions](https://novonordisk-opensource.github.io/connector/reference/log-functions.md)
for available logging functions.

- Default: `FALSE`

- Option: `connector.logging`

- Environment: `R_CONNECTOR_LOGGING`

### default_ext

Default extension to use when reading and writing files when not
specified in the file name. E.g. with the default 'csv', files are
assumed to be in CSV format if not specified.

- Default: `"csv"`

- Option: `connector.default_ext`

- Environment: `R_CONNECTOR_DEFAULT_EXT`
