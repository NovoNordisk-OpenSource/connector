# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Project Overview

The `connector` package is an R package that provides a unified
interface for accessing different data sources in clinical research. It
abstracts file systems, databases, and cloud storage behind a consistent
API, allowing users to switch between backends without changing their R
code.

## Development Commands

### Package Development

``` r
# Load package for development
devtools::load_all()

# Run all tests
devtools::test()

# Run specific test file
testthat::test_file('tests/testthat/test-fs.R')

# Check package (comprehensive check including examples and vignettes)
devtools::check()

# Install dependencies
devtools::install_deps(dependencies = TRUE)

# Generate documentation
devtools::document()

# Build package
devtools::build()

# Build and install locally
devtools::install()
```

### Code Quality

``` r
# Style check and auto-format
styler::style_pkg()

# Lint package for code quality issues
lintr::lint_package()

# Check test coverage
covr::report()

# Spell check
spelling::spell_check_package()
```

### Vignette and Documentation

``` r
# Build vignettes
devtools::build_vignettes()

# Build pkgdown site locally
pkgdown::build_site()
```

## Core Architecture

### Design Pattern: R6 + S3 Hybrid

The package uses a hybrid R6/S3 approach: - **R6 classes** (`Connector`,
`ConnectorFS`, `ConnectorDBI`) manage state and provide object-oriented
structure - **S3 generics**
([`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md),
[`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md),
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md))
provide familiar R method dispatch - **S3 methods** in `*_methods.R`
files bridge the gap between generics and R6 implementations

### Key Components

#### Configuration System (`connect.R`)

- [`connect()`](https://novonordisk-opensource.github.io/connector/reference/connect.md)
  function parses YAML configuration files
- Supports template interpolation with `{metadata.key}` syntax
- Validates configuration structure and creates appropriate backend
  objects
- Returns `connectors` object containing named backend instances

#### Generic System (`cnt_generics.R`)

Defines the complete API surface: - Core operations:
[`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md),
[`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md),
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md),
[`remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.md) -
File operations:
[`upload_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_cnt.md),
[`download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_cnt.md) -
Directory operations:
[`create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/create_directory_cnt.md),
[`remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.md) -
Database operations:
[`tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.md),
[`disconnect_cnt()`](https://novonordisk-opensource.github.io/connector/reference/disconnect_cnt.md)

#### Backend Resolution (`generic_backend.R`)

- `create_backend()` instantiates backends from configuration
- `get_backend_fct()` resolves backend type strings to constructor
  functions
- Supports both built-in backends (`connector_fs`, `connector_dbi`) and
  external packages (`package::function`)

#### File System Backend (`fs.R`, `fs_*.R`)

- `ConnectorFS` R6 class for file operations
- Format detection based on file extensions
- Conditional dependencies for different file formats (arrow, haven,
  readxl)
- Separate files for reading (`fs_read.R`), writing (`fs_write.R`), and
  methods (`fs_methods.R`)

#### Database Backend (`dbi.R`, `dbi_*.R`)

- `ConnectorDBI` R6 class for database operations
- Uses DBI interface for database-agnostic operations
- Automatic connection cleanup via `finalize()` method
- Lazy evaluation support through
  [`dplyr::tbl()`](https://dplyr.tidyverse.org/reference/tbl.html)

### Configuration File Structure

``` yaml
metadata:               # Optional: Template variables
  key: value
  
env:                    # Optional: Environment variables to set
  key: value
  
datasources:            # Required: Backend definitions
  - name: "unique_name"
    backend:
      type: "connector_fs"  # or "connector_dbi" or "package::function"
      # backend-specific parameters
```

### Testing Architecture

- Uses `testthat` (edition 3) for testing framework
- Test files organized by component (`test-fs.R`, `test-dbi.R`,
  `test-connect.R`)
- Uses
  [`withr::local_tempdir()`](https://withr.r-lib.org/reference/with_tempfile.html)
  for isolated file system tests
- Uses
  [`RSQLite::SQLite()`](https://rsqlite.r-dbi.org/reference/SQLite.html)
  with `:memory:` for database tests
- Snapshot testing for configuration validation and error messages

### Extension Pattern

New backends should: 1. Inherit from `Connector` R6 class 2. Implement
required methods in the class 3. Create constructor function following
`connector_*` naming convention 4. Add S3 method implementations in
separate `*_methods.R` file 5. Follow existing testing patterns

### Key Dependencies

- **Core**: R6, checkmate, cli, purrr, glue, yaml
- **File I/O**: fs, readr, arrow, haven, readxl, writexl, vroom
- **Database**: DBI, dplyr, dbplyr
- **Logging**: zephyr (required), whirl (optional)
- **Development**: testthat (edition 3), withr, devtools

### Error Handling

- Uses
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  for structured error messages
- Comprehensive parameter validation with `checkmate`
- Graceful handling of optional dependencies with
  [`requireNamespace()`](https://rdrr.io/r/base/ns-load.html)
- Helpful error messages for configuration issues

This architecture enables a consistent user experience across different
data sources while maintaining extensibility for new backends and file
formats.

## Development Workflow

### CI/CD Pipeline

The package uses GitHub Actions for continuous integration: -
**check_current_version**: Validates package version compliance -
**pkgdown**: Builds and deploys documentation site - **coverage**:
Generates test coverage reports via codecov - **megalinter**: Runs
comprehensive linting across multiple languages

### Package Structure

``` txt
R/                          # Core package code
├── connect.R              # Main entry point - connect() function
├── cnt_generics.R         # S3 generic definitions
├── connector.R            # Base R6 Connector class
├── fs*.R                  # File system backend implementation
├── dbi*.R                 # Database backend implementation
└── *_methods.R            # S3 method implementations

tests/testthat/            # Test suite
├── test-*.R              # Component tests
├── configs/              # Test configuration files
└── scripts/              # Test helper scripts

inst/
├── config/               # Example configuration files
└── examples/             # Usage examples

dev/                      # Development utilities (not included in package)
```

### Configuration Examples

The `inst/config/` directory contains reference configuration files: -
`_connector.yml`: Basic file system and database setup -
`default_config.yml`: Template with common patterns -
`example_for_generic.yml`: Generic backend demonstration

### Naming Conventions

- **R6 classes**: PascalCase (e.g., `ConnectorFS`, `ConnectorDBI`)
- **S3 generics**: snake_case with `_cnt` suffix (e.g.,
  [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md),
  [`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md))
- **Constructor functions**: `connector_*` prefix (e.g.,
  [`connector_fs()`](https://novonordisk-opensource.github.io/connector/reference/connector_fs.md),
  [`connector_dbi()`](https://novonordisk-opensource.github.io/connector/reference/connector_dbi.md))
- **Method files**: `*_methods.R` pattern for S3 implementations
- **Backend files**: Component-based grouping (`fs_read.R`,
  `fs_write.R`, `dbi_*.R`)
