# Developer Documentation - connector

## What is connector?

The connector package provides a unified interface for accessing different data sources in clinical research. It abstracts file systems, databases, and cloud storage behind a consistent API, allowing users to switch between backends without changing their R code.

## Package Structure

```
connector/
├── R/
│   ├── connector.R             # Main package file, package documentation
│   ├── connect.R               # connect() function, YAML config parsing
│   ├── connectors.R            # connectors class, collection management
│   ├── cnt_generics.R          # S3 generics: read_cnt(), write_cnt(), list_content_cnt()
│   ├── generic_backend.R       # Connector R6 base class
│   ├── fs.R                    # File system backend implementation
│   ├── fs_*.R                  # File system utilities (read, write, methods)
│   ├── dbi.R                   # Database backend implementation
│   ├── dbi_*.R                 # Database utilities (methods, tools)
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
- Package documentation and main exports
- Defines what users see when they load the package

**`R/connect.R`**
- `connect()` function - the main entry point for users
- YAML configuration parsing with `yaml::read_yaml()`
- Template interpolation (`{metadata.key}` resolution)
- Backend instantiation and validation
- Returns a `connectors` object containing all configured backends

**`R/connectors.R`**
- `connectors` class definition and methods
- Collection management for multiple connector instances
- Print methods and object inspection utilities

### Generic System

**`R/cnt_generics.R`**
- Defines all S3 generics: `read_cnt()`, `write_cnt()`, `list_content_cnt()`
- Provides the consistent API that works across all backends
- Method dispatch to backend-specific implementations

**`R/generic_backend.R`**
- `Connector` R6 base class that all backends inherit from
- Defines the interface contract for new backends
- Shared functionality like validation and logging hooks

### Backend Implementations

**`R/fs.R`**
- File system backend: `ConnectorFS` R6 class
- `connector_fs()` constructor function
- File format detection and delegation to appropriate readers
- Cross-platform path handling

**`R/fs_*.R`**
- `fs_read.R`: File reading logic with format detection
- `fs_write.R`: File writing with format selection
- `fs_methods.R`: S3 method implementations
- `fs_backend_tools.R`: Utility functions for file operations

**`R/dbi.R`**
- Database backend: `ConnectorDBI` R6 class
- `connector_dbi()` constructor function
- DBI connection management and SQL operations

**`R/dbi_*.R`**
- `dbi_methods.R`: S3 method implementations for database operations
- `dbi_backend_tools.R`: Utility functions for database operations

### Configuration and Utilities

**`R/utils_config.R`**
- YAML configuration validation and parsing
- Schema enforcement for configuration files
- Template interpolation engine
- Error handling for malformed configurations

**`R/utils_files.R`**
- File handling utilities
- Path validation and normalization
- File format detection helpers

## How connector Works

### 1. Configuration Loading
```
YAML file → yaml::read_yaml() → parse_config() → validate schema → interpolate templates
```

### 2. Backend Creation
```
config → iterate datasources → create R6 backend objects → wrap in connectors object
```

### 3. Method Dispatch
```
read_cnt(connector, "data") → UseMethod("read_cnt") → read_cnt.ConnectorFS → connector$read_cnt()
```

## Architecture Decisions

### S3 + R6 Combination
- **S3 generics** provide familiar R interface and easy extensibility
- **R6 classes** manage backend state and enable clean inheritance
- **S3 methods** delegate to R6 methods for actual implementation

### Configuration-Driven Design
- All connection details specified in YAML files
- Template system allows reusable configurations
- Strict validation prevents runtime errors

### Backend Abstraction
- Common interface across all data sources
- Backend-specific optimizations hidden from users
- Easy to add new backends without breaking existing code

## Testing Structure

### Test Organization
- `test-connect.R`: Configuration parsing and `connect()` function
- `test-connectors.R`: `connectors` object behavior
- `test-fs.R`: File system backend functionality
- `test-dbi.R`: Database backend functionality
- `test-generics.R`: S3 generic method dispatch
- `test-integration.R`: End-to-end workflows

### Test Patterns
- Each backend follows same testing template
- Heavy use of `withr` for resource management
- Mock external dependencies for reliable tests
- Performance benchmarks for critical paths

## Extension Points

### Adding New Backends
1. Create R6 class inheriting from `Connector`
2. Implement required methods: `read_cnt`, `write_cnt`, `list_content_cnt`
3. Add constructor function following naming convention
4. Register S3 methods for method dispatch
5. Add comprehensive tests following existing patterns

### Backend Packages
- `connector.databricks`: Databricks integration
- `connector.sharepoint`: SharePoint/Office 365 integration
- Extension packages register their own backends

## File Format Support

### File System Backend
- **Parquet**: Via `arrow` package for analytical workloads
- **CSV**: Via `readr` and `vroom` for large files
- **Excel**: Via `readxl` and `writexl`
- **SAS**: Via `haven` for clinical data
- **RDS**: Native R serialization

### Database Backend
- **SQLite**: Via `RSQLite` for local databases
- **PostgreSQL**: Via `RPostgres` for production databases
- **SQL Server**: Via `odbc` for enterprise environments
- Extensible through DBI-compatible drivers