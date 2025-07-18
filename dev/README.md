# Developer Documentation - connector

## What is connector?

The connector package provides a unified interface for accessing different data sources in clinical research. It abstracts file systems, databases, and cloud storage behind a consistent API, allowing users to switch between backends without changing their R code.

## Package Structure

```
connector/
├── R/
│   ├── connector.R             # Connector R6 base class definition
│   ├── connect.R               # connect() function, YAML config parsing
│   ├── connectors.R            # connectors class, collection management
│   ├── cnt_generics.R          # S3 generics: read_cnt(), write_cnt(), list_content_cnt()
│   ├── fs.R                    # ConnectorFS R6 class, connector_fs() constructor
│   ├── fs_*.R                  # File system utilities (read, write, methods, tools)
│   ├── dbi.R                   # ConnectorDBI R6 class, connector_dbi() constructor
│   ├── dbi_*.R                 # Database utilities (methods, tools)
│   ├── generic_backend.R       # Backend creation utilities
│   ├── logger_*.R              # Logging system for audit trails
│   ├── utils_*.R               # Config validation, file handling
│   └── conts_datasources.R     # Data source management
├── tests/testthat/             # Test suite
├── vignettes/                  # User documentation
└── dev/                        # Developer documentation
```

## Key Files and Their Role

### Core Entry Points

**`R/connector.R`**
- `Connector` R6 base class that all backends inherit from
- Defines abstract methods: `read_cnt()`, `write_cnt()`, `list_content_cnt()`
- Provides `print_cnt()` method for displaying connector info

**`R/connect.R`**
- `connect()` function - main entry point that parses YAML config
- `parse_config()` - handles template interpolation and validation
- `create_connection()` - instantiates appropriate backend objects
- Returns a `connectors` object containing all configured backends

**`R/connectors.R`**
- `connectors()` function creates collection of connector objects
- `nested_connectors()` for hierarchical configurations
- Print methods for displaying connector collections

### Generic System

**`R/cnt_generics.R`**
- Defines S3 generics: `read_cnt()`, `write_cnt()`, `list_content_cnt()`
- Also includes: `remove_cnt()`, `upload_cnt()`, `download_cnt()`, `tbl_cnt()`
- Provides consistent API across all backend implementations

**`R/generic_backend.R`**
- `create_backend()` - creates backend objects from config
- `get_backend_fct()` - resolves backend type strings to functions
- `try_connect()` - handles connection attempts with error handling

### Backend Implementations

**`R/fs.R`**
- `ConnectorFS` R6 class for file system operations
- `connector_fs()` constructor function
- Inherits from `Connector` base class

**`R/fs_*.R`**
- `fs_read.R`: File reading with format detection
- `fs_write.R`: File writing with format selection
- `fs_methods.R`: S3 method implementations
- `fs_backend_tools.R`: File system utilities

**`R/dbi.R`**
- `ConnectorDBI` R6 class for database operations
- `connector_dbi()` constructor function
- Manages DBI connections and SQL operations

**`R/dbi_*.R`**
- `dbi_methods.R`: S3 method implementations
- `dbi_backend_tools.R`: Database utilities

### Configuration and Utilities

**`R/utils_config.R`**
- `add_metadata()`, `remove_metadata()` - modify config files
- `add_datasource()`, `remove_datasource()` - manage datasources
- Configuration manipulation utilities

**`R/utils_files.R`**
- File handling utilities used by file system backend

## How connector Works

### 1. Configuration Loading
```
YAML file → connect() → parse_config() → create_connection() → backend objects
```

### 2. Backend Creation
```
config → create_backend() → get_backend_fct() → connector_fs() or connector_dbi()
```

### 3. Method Dispatch
```
read_cnt(connector, "data") → UseMethod("read_cnt") → read_cnt.ConnectorFS → fs methods
```

## Architecture Decisions

### R6 Base Class with S3 Generics
- **R6 `Connector` class** provides shared interface and state management
- **S3 generics** in `cnt_generics.R` provide familiar R method dispatch
- **Backend-specific methods** in `*_methods.R` files implement the generics

### Configuration System
- YAML files with `metadata`, `env`, and `datasources` sections
- Template interpolation using `{metadata.key}` syntax
- Strict validation in `connect.R` with helpful error messages

### Backend Type Resolution
- Backend types specified as strings: `"connector::connector_fs"`
- `get_backend_fct()` resolves to actual constructor functions
- Supports external packages: `"connector.databricks::connector_databricks"`

## Testing Structure

### Test Organization
- `test-connect.R`: Configuration parsing and `connect()` function
- `test-connectors.R`: `connectors` object behavior
- `test-fs.R`: File system backend functionality
- `test-dbi.R`: Database backend functionality
- `test-generics.R`: S3 generic method dispatch
- `test-integration.R`: End-to-end workflows

### Test Patterns
- Each backend follows consistent testing structure
- Use `withr::local_tempdir()` for file system tests
- Use `RSQLite::SQLite()` with `:memory:` for database tests
- Mock external dependencies for reliable tests

## Extension Points

### Adding New Backends
1. Create R6 class inheriting from `Connector`
2. Implement required methods in the class
3. Create constructor function following `connector_*` naming
4. Add S3 methods in separate `*_methods.R` file
5. Add comprehensive tests following existing patterns

### Backend Packages
- Extension packages can add new backend types
- Use naming convention: `connector.{service}`
- Examples: `connector.databricks`, `connector.sharepoint`

## File Format Support

### File System Backend
- **Format detection**: Automatic based on file extension
- **Parquet**: Via `arrow` package (preferred for analytics)
- **CSV**: Via `readr` and `vroom` packages
- **Excel**: Via `readxl` and `writexl` packages
- **SAS**: Via `haven` package for `.sas7bdat` files
- **RDS**: Native R serialization format

### Database Backend
- **DBI compliance**: Works with any DBI-compatible driver
- **SQLite**: Via `RSQLite` package
- **PostgreSQL**: Via `RPostgres` package
- **SQL Server**: Via `odbc` package
- **Lazy evaluation**: Uses `dplyr::tbl()` for query building

## Logging System

### Audit Trail
- Optional logging via `logger_*.R` files
- Integrates with `whirl` package for structured logging
- Tracks read/write operations with timestamps
- Configurable through `logging` option