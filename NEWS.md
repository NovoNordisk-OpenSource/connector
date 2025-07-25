# connector 0.1.1.9004 (development version)

## Breaking Changes
* **Parameter name changes**: The `upload_cnt()`, `download_cnt()`, `upload_directory_cnt()`, and `download_directory_cnt()` functions now use `src` and `dest` parameters instead of `name`/`file` and `dir`/`name` for consistency across the API. Update your code accordingly:
  - `upload_cnt(file = "path", name = "target")` → `upload_cnt(src = "path", dest = "target")`
  - `download_cnt(name = "source", file = "path")` → `download_cnt(src = "source", dest = "path")`
  - `upload_directory_cnt(dir = "path", name = "target")` → `upload_directory_cnt(src = "path", dest = "target")`
  - `download_directory_cnt(name = "source", dir = "path")` → `download_directory_cnt(src = "source", dest = "path")`

## Enhancements
* Added upload_cnt and download_cnt methods for ConnectorLogger
* Added resource validation system with `validate_resource()` function and `check_resource()` S3 methods

## Bugs

* Fixed bug in connectors function. You can now pass a R Object.

## Other
* Reformat code with air
* Update unit tests
* Rearrange documentation
* Added unit tests for resource validation

# connector 0.1.1

## Enhancements
* Added pkgdown url to Description
* Added codecov in the workflow and badge 
* Used an invisible return of the path for yaml manipulation functions

## Other
* Resolve the comments from our initial CRAN release
    * Always using tempdir() in our examples and tests
    * Never write to user library
    * Remove examples using system.file() from non exported functions (to save time on rewriting them)
    * Silenced messages in tests for an easier overview

## Bugs
* Fixed url for GitHub Actions badge

# connector 0.1.0

## Enhancements
* Prepare for Cran release
* Use option for logging param
* Adapt UT for whirl 0.2.0

## Bugs
* Fix overwrite issue for writing files

# connector 0.0.9

Enhancements
* Fix yaml dependency and xlsm extension
* Add zephyr and remove options package.
* Fix pkgdown problems with `Connector` class.
* Added `upload_directory_cnt()` and `download_directory_cnt()` generics relevant for `ConnectorFS`.
* Remove `overwrite` option from `Connector` `write_cnt()` class method.

# connector 0.0.8

## Breaking Changes
* Changed connector class names from `connector` to `Connector`, `connector_fs` to `ConnectorFS`, etc,
* Added wrapper functions for the new class names.
* Fixed documentation for the new class names.

## Enhancements
* Removed test dependency package {mockery} as it has been deprecated. Using recommended testthat::local_mocked_bindings() instead.
* Add precommit to the repo and change code according to errors.
* Add github templates for easier development and issue handling.

# connector 0.0.7

## Features
* Modified `vignettes/customize.Rmd` to ensure internal pipeline run successfully.

# connector 0.0.6

## Breaking Changes
* Removed dependency on {connector.logger} package. Logging functionality is now integrated directly into {connector} using {whirl}.

## Features
* Added integrated logging functionality using {whirl}.
* Implemented `log_read_connector()`, `log_write_connector()`, and `log_remove_connector()` generics and methods for different connector types.
* Connectors constructor now builds the datasources attribute.
* Added ability to write datasources attribute to a configuration file.
* Created a new class for nested connectors objects, "nested_connectors".
* Added `tbl_cnt` to `ConnectorFS` for redundancy between `fs` and `dbi` types of connectors.

## Enhancements
* Fixed `add_logs()` function to add logging capability to connections.
* Enhanced CI compatibility in vignettes by adding a condition to set working directory when running in a CI environment.
* Expanded test coverage to include new logging functionality.

# connector 0.0.5 (2025-01-15)

### Features:
-   Add configuration manipulation functions for adding/removing metadata and datasources
-   `ConnectorDBI` now overwrites tables by default, to have mirror behaviour between `fs` and `dbi` connectors.

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
