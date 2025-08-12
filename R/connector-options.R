#' @title Options for connector
#' @name connector-options
#' @description
#' `r zephyr::list_options(as = "markdown", .envir = "connector")`
NULL

#' @title Internal parameters for reuse in functions
#' @name connector-options-params
#' @eval zephyr::list_options(as = "params", .envir = "connector")
#' @details
#' See [connector-options] for more information.
#' @keywords internal
NULL

zephyr::create_option(
  name = "verbosity_level",
  default = "verbose",
  desc = "Verbosity level for functions in connector.
  See [zephyr::verbosity_level] for details."
)

zephyr::create_option(
  name = "overwrite",
  default = FALSE,
  desc = "Overwrite existing content if it exists in the connector? 
  See [connector-options] for details. Default can be set globally with 
  `options(connector.overwrite = TRUE/FALSE)` or environment variable 
  `R_CONNECTOR_OVERWRITE`."
)

zephyr::create_option(
  name = "logging",
  default = FALSE,
  desc = "Add logging capability to connectors using [add_logs()]. 
  When `TRUE`, all connector operations will be logged to the console and 
  to whirl log HTML files. See [logger_generics] for available 
  logging functions."
)

zephyr::create_option(
  name = "default_ext",
  default = "csv",
  desc = "Default extension to use when reading and writing files when not 
  specified in the file name. E.g. with the default 'csv', files are assumed 
  to be in CSV format if not specified."
)
