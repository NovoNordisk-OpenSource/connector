# Resource Validation System for Connector Objects

This module provides a flexible validation system to verify that
resources required by connector objects exist and are accessible. The
validation is performed through S3 method dispatch, allowing each
connector class to define its own validation logic while providing a
consistent interface.

## Usage

``` r
validate_resource(x)

check_resource(self)

# S3 method for class 'Connector'
check_resource(self)

# S3 method for class 'ConnectorFS'
check_resource(self)
```

## Arguments

- x:

  Connector object to validate.

- self:

  Connector object for method dispatch.

## Architecture

The system is built around two main components:

- `validate_resource()`: A dispatcher function that finds and executes
  the appropriate S3 method based on the connector's class

- `check_resource()`: A generic S3 method that defines the validation
  interface for all connector types

## Method Resolution

The validation process follows this hierarchy:

1.  Attempt to find a class-specific method (e.g.,
    `check_resource.ConnectorFS`)

2.  If no specific method exists, fall back to the default
    `check_resource.Connector`

3.  Execute the resolved method with appropriate error handling

## Available S3 Methods

- `check_resource.Connector`:

  Default method that performs no validation. Serves as a safe fallback
  for connector classes without specific validation needs.

- `check_resource.ConnectorFS`:

  Validates file system resources by checking directory existence using
  [`fs::dir_exists()`](https://fs.r-lib.org/reference/file_access.html).
  Throws informative errors for missing directories.

## Implementation Guidelines

When implementing new connector classes with resource validation:

- Define a method following the pattern `check_resource.<YourClass>`

- Return `NULL` on successful validation

- Use
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  for validation failures to provide consistent error formatting

- Include `call = rlang::caller_env()` in error calls for proper error
  context

## Error Handling

The validation system provides robust error handling:

- Method resolution failures are handled gracefully with fallback to
  default

- Validation errors include contextual information about the failing
  resource

- Error messages use `cli` formatting for consistency across the package

## Examples

``` r
# Basic validation for a file system connector

fs_connector <- try(ConnectorFS$new(path = "doesn_t_exists"), silent = TRUE)
fs_connector
#> [1] "Error in validate_resource(self) : \n  \033[1m\033[22mInvalid file system connector: \033[34mdoesn_t_exists\033[39m does not exist.\n"
#> attr(,"class")
#> [1] "try-error"
#> attr(,"condition")
#> <error/rlang_error>
#> Error in `validate_resource()`:
#> ! Invalid file system connector: doesn_t_exists does not exist.
#> ---
#> Backtrace:
#>      ▆
#>   1. └─pkgdown::build_site_github_pages(new_process = FALSE, install = FALSE)
#>   2.   └─pkgdown::build_site(...)
#>   3.     └─pkgdown:::build_site_local(...)
#>   4.       └─pkgdown::build_reference(...)
#>   5.         ├─pkgdown:::unwrap_purrr_error(...)
#>   6.         │ └─base::withCallingHandlers(...)
#>   7.         └─purrr::map(...)
#>   8.           └─purrr:::map_("list", .x, .f, ..., .progress = .progress)
#>   9.             ├─purrr:::with_indexed_errors(...)
#>  10.             │ └─base::withCallingHandlers(...)
#>  11.             ├─purrr:::call_with_cleanup(...)
#>  12.             └─pkgdown (local) .f(.x[[i]], ...)
#>  13.               ├─base::withCallingHandlers(...)
#>  14.               └─pkgdown:::data_reference_topic(...)
#>  15.                 └─pkgdown:::run_examples(...)
#>  16.                   └─pkgdown:::highlight_examples(code, topic, env = env)
#>  17.                     └─downlit::evaluate_and_highlight(...)
#>  18.                       └─evaluate::evaluate(code, child_env(env), new_device = TRUE, output_handler = output_handler)
#>  19.                         ├─base::withRestarts(...)
#>  20.                         │ └─base (local) withRestartList(expr, restarts)
#>  21.                         │   ├─base (local) withOneRestart(withRestartList(expr, restarts[-nr]), restarts[[nr]])
#>  22.                         │   │ └─base (local) doWithOneRestart(return(expr), restart)
#>  23.                         │   └─base (local) withRestartList(expr, restarts[-nr])
#>  24.                         │     └─base (local) withOneRestart(expr, restarts[[1L]])
#>  25.                         │       └─base (local) doWithOneRestart(return(expr), restart)
#>  26.                         ├─evaluate:::with_handlers(...)
#>  27.                         │ ├─base::eval(call)
#>  28.                         │ │ └─base::eval(call)
#>  29.                         │ └─base::withCallingHandlers(...)
#>  30.                         ├─base::withVisible(eval(expr, envir))
#>  31.                         └─base::eval(expr, envir)
#>  32.                           └─base::eval(expr, envir)
#>  33.                             ├─base::try(ConnectorFS$new(path = "doesn_t_exists"), silent = TRUE)
#>  34.                             │ └─base::tryCatch(...)
#>  35.                             │   └─base (local) tryCatchList(expr, classes, parentenv, handlers)
#>  36.                             │     └─base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
#>  37.                             │       └─base (local) doTryCatch(return(expr), name, parentenv, handler)
#>  38.                             └─ConnectorFS$new(path = "doesn_t_exists")
#>  39.                               └─connector (local) initialize(...)
#>  40.                                 └─super$initialize(extra_class = extra_class)
#>  41.                                   └─connector::validate_resource(self)

```
