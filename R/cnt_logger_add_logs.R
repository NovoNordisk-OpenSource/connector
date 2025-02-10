#' Add Logging Capability to Connections
#'
#' This function adds logging capability to a list of connections by modifying
#' their class attributes. It ensures that the input is of the correct type and
#' registers the necessary S3 methods for logging.
#'
#' @param connections An object of class [connector::connectors()]. This should be a list
#'   of connection objects to which logging capability will be added.
#'
#' @return The modified `connections` object with logging capability added.
#'   Each connection in the list will have the "connector_logger" class
#'   prepended to its existing classes.
#'
#' @details
#' The function performs the following steps:
#' 1. Checks if the input `connections` is of class "connectors".
#' 2. Registers the S3 methods for logging using `connector.logger::cnt_logger_S3_register()`.
#' 3. Iterates through each connection in the list and prepends the "connector_logger" class.
#'
#' @examplesIf FALSE
#' logged_connections <- add_logs(my_connections)
#'
#' @export
add_logs <- function(connections) {
  stopifnot(inherits(connections, "connectors"))

  for (i in seq_along(connections)) {
    class(connections[[i]]) <- c("connector_logger", class(connections[[i]]))
  }

  connections
}

#' Print Method for connector_logger objects
#'
#' @param ... Additional arguments passed to the next method.
#'
#' @return The result of the next method in the dispatch chain.
#'
#' @details
#' This method is designed to be called automatically when `print()` is used
#' on an object of class "connector_logger". It uses `NextMethod()` to call
#' the next appropriate method in the method dispatch chain, allowing for
#' the default or any other custom print behavior to be executed.
#'
#' @seealso \code{\link{print}}
#'
#' @export
#' @method print connector_logger
print.connector_logger <- function(...) {
  NextMethod(...)
}
