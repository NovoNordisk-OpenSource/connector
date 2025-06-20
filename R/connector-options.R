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
  desc = "Add logs to the console as well as to the whirl log html files"
)
