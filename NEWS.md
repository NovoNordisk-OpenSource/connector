# connector (development version)


# connector 0.0.6

## Breaking Changes
* Removed dependency on {connector.logger} package. Logging functionality is now integrated directly into {connector} using {whirl}.

## Features
* Added integrated logging functionality using {whirl}.
* Implemented `log_read_connector()`, `log_write_connector()`, and `log_remove_connector()` generics and methods for different connector types.
* Connectors constructor now builds the datasources attribute.
* Added ability to write datasources attribute to a configuration file.
* Created a new class for nested connectors objects, "nested_connectors".
* Added `tbl_cnt` to `connector_fs` for redundancy between `fs` and `dbi` types of connectors.

## Enhancements
* Fixed `add_logs()` function to add logging capability to connections.
* Enhanced CI compatibility in vignettes by adding a condition to set working directory when running in a CI environment.
* Expanded test coverage to include new logging functionality.

# connector 0.0.5 (2025-01-15)

### Features:
-   Add configuration manipulation functions for adding/removing metadata and datasources
-   `connector_dbi` now overwrites tables by default, to have mirror behaviour between `fs` and `dbi` connectors.

# connector 0.0.4 (2024-12-03)

### Migration:
-   Migration to public github

### Features:
-   Update of `create_directory_cnt()`
-   Added metadata as a parameter in `connect()`
-   More comprehensive testing
-   Better integration with [whirl](https://github.com/NovoNordisk-OpenSource/whirl) through [connector.logger](https://github.com/NovoNordisk-OpenSource/connector.logger)

### Other:
-   Reducing the number of dependencies.
-   Better messages

# connector 0.0.3 (2024-09-25)

### Breaking Changes:
-   rename function from `*_cnt` to `cnt_`

### Features:
-   Nested connectors objects
-   Use active bindings
-   User guide added


# connector 0.0.2

-   Added `connectors` super class

# connector 0.0.1

-   Initial version
