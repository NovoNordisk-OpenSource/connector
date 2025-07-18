# Quick Start - connector Development

## Setup (5 minutes)

```bash
git clone https://github.com/NovoNordisk-OpenSource/connector
cd connector
R -e "devtools::install_deps(dependencies = TRUE)"
R -e "devtools::load_all(); devtools::test()"
```

## Test connector Works

```r
devtools::load_all()

# Test file system backend
temp_dir <- tempdir()
fs_cnt <- connector_fs(temp_dir)
write_cnt(fs_cnt, mtcars, "cars.csv")
result <- read_cnt(fs_cnt, "cars.csv")
nrow(result) == nrow(mtcars)

# Test database backend
db_cnt <- connector_dbi(RSQLite::SQLite(), ":memory:")
write_cnt(db_cnt, iris, "iris_table")
result <- read_cnt(db_cnt, "iris_table")
nrow(result) == nrow(iris)
```

## Test Config System

```r
config_content <- '
metadata:
  data_path: !expr tempdir()

datasources:
  - name: "files"
    backend:
      type: "connector::connector_fs"
      path: "{metadata.data_path}"
  - name: "db"
    backend:
      type: "connector::connector_dbi"
      drv: "RSQLite::SQLite()"
      dbname: ":memory:"
'

config_file <- tempfile(fileext = ".yml")
writeLines(config_content, config_file)

db <- connect(config_file)
print(db)

# Test both backends
write_cnt(db$files, mtcars, "test.csv")
write_cnt(db$db, mtcars, "test_table")

read_cnt(db$files, "test.csv")
read_cnt(db$db, "test_table")
```

## Development Workflow

### Making Changes

1. **Edit R files** in `R/` directory
2. **Reload package**: `devtools::load_all()`
3. **Test changes**: `devtools::test()`
4. **Check style**: `styler::style_pkg()`

### Adding a Function

```r
# In appropriate R/ file
validate_name <- function(name) {
  checkmate::assert_string(name, min.chars = 1)
  checkmate::assert_names(name, type = "unique")
  name
}
```

### Adding Tests

```r
# In tests/testthat/test-utils.R
test_that("validate_name works", {
  expect_equal(validate_name("test"), "test")
  expect_error(validate_name(""))
  expect_error(validate_name(123))
})
```

## Working with Backends

### File System Backend

```r
temp_dir <- withr::local_tempdir()
fs_cnt <- connector_fs(temp_dir)

# Test different formats
write_cnt(fs_cnt, iris, "test.csv")
write_cnt(fs_cnt, iris, "test.rds")
write_cnt(fs_cnt, iris, "test.parquet")

# Read back
csv_data <- read_cnt(fs_cnt, "test.csv")
rds_data <- read_cnt(fs_cnt, "test.rds")
parquet_data <- read_cnt(fs_cnt, "test.parquet")

# List files
list_content_cnt(fs_cnt)
```

### Database Backend

```r
db_cnt <- connector_dbi(RSQLite::SQLite(), ":memory:")

# Write and read tables
write_cnt(db_cnt, mtcars, "cars")
write_cnt(db_cnt, iris, "flowers")

cars_data <- read_cnt(db_cnt, "cars")
iris_data <- read_cnt(db_cnt, "flowers")

# List tables
list_content_cnt(db_cnt)
```

## Debugging Common Issues

### Package won't load
```r
devtools::clean_dll()
devtools::install_deps(dependencies = TRUE)
devtools::load_all()
```

### Tests failing
```r
# Run single test file
testthat::test_file("tests/testthat/test-fs.R")

# Debug specific test
test_that("debug test", {
  if (interactive()) browser()
  # test code here
})
```

### Config not parsing
```r
# Check config syntax
config_path <- "your_config.yml"
config <- yaml::read_yaml(config_path, eval.expr = TRUE)

# Test parsing
parsed <- parse_config(config)
```

## Key Functions

```r
# Main API
connect()              # Parse config, create connectors
read_cnt()             # Read from any backend
write_cnt()            # Write to any backend  
list_content_cnt()     # List available resources

# Backend constructors
connector_fs()         # File system backend
connector_dbi()        # Database backend

# Development tools
devtools::load_all()   # Reload package
devtools::test()       # Run tests
devtools::check()      # Full package check
```

## Next Steps

1. **Read technical-design.md** for implementation details
2. **Browse R/ files** to understand code structure
3. **Check existing tests** for testing patterns
4. **Look at vignettes** for user examples