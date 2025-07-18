# Technical Design - connector Package

## connector's S3 + R6 Architecture

### The Pattern

connector uses S3 generics that dispatch to R6 methods. This gives us:
- **Familiar R interface**: Users call `read_cnt(connector, "data")`
- **Stateful backends**: R6 objects manage connections and configuration
- **Clean extensibility**: New backends just implement the interface

```r
# S3 generic in cnt_generics.R
read_cnt <- function(cnt, ...) UseMethod("read_cnt")

# R6 backend in fs.R
ConnectorFS <- R6Class("ConnectorFS",
  inherit = Connector,
  public = list(
    initialize = function(path) {
      private$.path <- normalizePath(path)
    },
    read_cnt = function(name, ...) {
      file_path <- file.path(private$.path, name)
      read_file(file_path, ...)
    }
  ),
  private = list(.path = NULL)
)

# S3 method bridges to R6 in fs_methods.R
read_cnt.ConnectorFS <- function(cnt, name, ...) {
  cnt$read_cnt(name, ...)
}
```

### Why This Design?

1. **Method dispatch**: S3 automatically routes to correct backend
2. **State management**: R6 handles connection objects, paths, credentials
3. **Inheritance**: New backends inherit common functionality
4. **Extensibility**: Extension packages can add backends without modifying core

## connector's Configuration System

### YAML Structure

The config system in `connect.R` and `utils_config.R` enforces this structure:

```yaml
metadata:               # Template variables
  study: "STUDY001"
  base_path: "/data"
  
datasources:            # Backend definitions
  - name: "adam"
    backend:
      type: "connector::connector_fs"
      path: "{metadata.base_path}/{metadata.study}/adam"
  - name: "database"
    backend:
      type: "connector::connector_dbi"
      drv: "RPostgres::Postgres()"
      host: "localhost"
      dbname: "{metadata.study}"
```

### Template Interpolation

The `interpolate_templates()` function in `utils_config.R` resolves `{metadata.key}` references:

```r
# Before interpolation
path: "{metadata.base_path}/{metadata.study}/adam"

# After interpolation  
path: "/data/STUDY001/adam"
```

### Config Validation

`parse_config()` validates:
- Required fields (`datasources`, `backend.type`)
- Proper nesting structure
- Template reference validity
- Backend type format (`package::function`)

## connector's Backend System

### Base Connector Class

All backends inherit from `Connector` in `generic_backend.R`:

```r
Connector <- R6Class("Connector",
  public = list(
    # Abstract methods - backends must implement
    read_cnt = function(name, ...) {
      stop("read_cnt not implemented", call. = FALSE)
    },
    write_cnt = function(x, name, ...) {
      stop("write_cnt not implemented", call. = FALSE)
    },
    list_content_cnt = function(...) {
      stop("list_content_cnt not implemented", call. = FALSE)
    },
    
    # Shared functionality
    disconnect_cnt = function() {
      # Default implementation
    }
  )
)
```

### File System Backend Implementation

`ConnectorFS` in `fs.R` implements file operations:

```r
ConnectorFS <- R6Class("ConnectorFS",
  inherit = Connector,
  public = list(
    initialize = function(path) {
      checkmate::assert_string(path)
      checkmate::assert_directory_exists(path)
      private$.path <- normalizePath(path)
    },
    
    read_cnt = function(name, ...) {
      file_path <- file.path(private$.path, name)
      read_file(file_path, ...)  # Delegates to fs_read.R
    },
    
    write_cnt = function(x, name, ...) {
      file_path <- file.path(private$.path, name)
      write_file(x, file_path, ...)  # Delegates to fs_write.R
    },
    
    list_content_cnt = function(...) {
      fs::dir_ls(private$.path, type = "file")
    }
  ),
  private = list(.path = NULL)
)
```

### Database Backend Implementation

`ConnectorDBI` in `dbi.R` manages database connections:

```r
ConnectorDBI <- R6Class("ConnectorDBI",
  inherit = Connector,
  public = list(
    initialize = function(drv, ...) {
      private$.conn <- DBI::dbConnect(drv, ...)
    },
    
    read_cnt = function(name, ...) {
      if (DBI::dbExistsTable(private$.conn, name)) {
        DBI::dbReadTable(private$.conn, name)
      } else {
        stop("Table '", name, "' does not exist")
      }
    },
    
    write_cnt = function(x, name, overwrite = FALSE, ...) {
      DBI::dbWriteTable(private$.conn, name, x, overwrite = overwrite, ...)
    },
    
    list_content_cnt = function(...) {
      DBI::dbListTables(private$.conn)
    }
  ),
  private = list(.conn = NULL)
)
```

## connector's Error Handling

### Error Classes

connector defines specific error classes in `utils_*.R`:

```r
# Error hierarchy
connector_error
├── connector_config_error      # Configuration parsing/validation
├── connector_connection_error  # Backend connection issues
├── connector_data_error       # Data reading/writing problems
└── connector_file_error       # File system operations
```

### Error Messages

Using `cli::cli_abort()` for structured messages:

```r
# In fs_read.R
if (!file.exists(path)) {
  cli::cli_abort(c(
    "File not found: {.path {path}}",
    "i" = "Check that the file exists and path is correct"
  ), class = "connector_file_error")
}

# In utils_config.R
if (is.null(config$datasources)) {
  cli::cli_abort(c(
    "Configuration missing required 'datasources' field",
    "i" = "Add datasources array to your config file"
  ), class = "connector_config_error")
}
```

## connector's File Format Handling

### Format Detection

`read_file()` in `fs_read.R` detects formats by extension:

```r
read_file <- function(path, ...) {
  ext <- tools::file_ext(path)
  
  switch(ext,
    "csv" = readr::read_csv(path, ...),
    "parquet" = {
      if (requireNamespace("arrow", quietly = TRUE)) {
        arrow::read_parquet(path, ...)
      } else {
        stop("Install 'arrow' package for parquet support")
      }
    },
    "rds" = readRDS(path),
    "sas7bdat" = {
      if (requireNamespace("haven", quietly = TRUE)) {
        haven::read_sas(path, ...)
      } else {
        stop("Install 'haven' package for SAS support")
      }
    },
    # Default to CSV
    readr::read_csv(path, ...)
  )
}
```

### Format Selection

`write_file()` in `fs_write.R` selects format by extension:

```r
write_file <- function(x, path, ...) {
  ext <- tools::file_ext(path)
  
  switch(ext,
    "csv" = readr::write_csv(x, path, ...),
    "parquet" = {
      if (requireNamespace("arrow", quietly = TRUE)) {
        arrow::write_parquet(x, path, ...)
      } else {
        stop("Install 'arrow' package for parquet support")
      }
    },
    "rds" = saveRDS(x, path),
    # Default to CSV
    readr::write_csv(x, path, ...)
  )
}
```

## connector's Generic System

### Generic Definitions

`cnt_generics.R` defines all S3 generics:

```r
#' @export
read_cnt <- function(cnt, ...) UseMethod("read_cnt")

#' @export
write_cnt <- function(cnt, ...) UseMethod("write_cnt")

#' @export
list_content_cnt <- function(cnt, ...) UseMethod("list_content_cnt")

#' @export
disconnect_cnt <- function(cnt, ...) UseMethod("disconnect_cnt")
```

### Method Registration

Each backend registers methods in its `*_methods.R` file:

```r
# In fs_methods.R
#' @export
read_cnt.ConnectorFS <- function(cnt, name, ...) {
  cnt$read_cnt(name, ...)
}

#' @export
write_cnt.ConnectorFS <- function(cnt, x, name, ...) {
  cnt$write_cnt(x, name, ...)
}

# In dbi_methods.R  
#' @export
read_cnt.ConnectorDBI <- function(cnt, name, ...) {
  cnt$read_cnt(name, ...)
}

#' @export
write_cnt.ConnectorDBI <- function(cnt, x, name, ...) {
  cnt$write_cnt(x, name, ...)
}
```

## Adding New Backends to connector

### Step 1: Create R6 Class

```r
# In R/mybackend.R
ConnectorMyBackend <- R6Class("ConnectorMyBackend",
  inherit = Connector,
  public = list(
    initialize = function(endpoint, token) {
      private$.endpoint <- endpoint
      private$.token <- token
      private$.client <- create_client(endpoint, token)
    },
    
    read_cnt = function(name, ...) {
      # Implementation specific to your backend
    },
    
    write_cnt = function(x, name, ...) {
      # Implementation specific to your backend
    },
    
    list_content_cnt = function(...) {
      # Implementation specific to your backend
    }
  ),
  private = list(
    .endpoint = NULL,
    .token = NULL,
    .client = NULL
  )
)
```

### Step 2: Add Constructor

```r
# In R/mybackend.R
#' @export
connector_mybackend <- function(endpoint, token) {
  ConnectorMyBackend$new(endpoint, token)
}
```

### Step 3: Register S3 Methods

```r
# In R/mybackend_methods.R
#' @export
read_cnt.ConnectorMyBackend <- function(cnt, name, ...) {
  cnt$read_cnt(name, ...)
}

#' @export
write_cnt.ConnectorMyBackend <- function(cnt, x, name, ...) {
  cnt$write_cnt(x, name, ...)
}

#' @export
list_content_cnt.ConnectorMyBackend <- function(cnt, ...) {
  cnt$list_content_cnt(...)
}
```

### Step 4: Add Tests

```r
# In tests/testthat/test-mybackend.R
test_that("mybackend works", {
  skip_if_not_installed("mybackend_package")
  
  backend <- connector_mybackend("test_endpoint", "test_token")
  
  # Test write
  write_cnt(backend, mtcars, "test_data")
  
  # Test read
  result <- read_cnt(backend, "test_data")
  expect_equal(result, mtcars)
  
  # Test list
  content <- list_content_cnt(backend)
  expect_contains(content, "test_data")
})
```

This design keeps connector extensible while maintaining a consistent interface across all backends.