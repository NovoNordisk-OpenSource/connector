#' Create a New Connector Logger
#'
#' @title Create a New Connector Logger
#' @description Creates a new empty connector logger object of class
#' "ConnectorLogger".
#' This is an S3 class constructor that initializes a logging structure for
#' connector operations.
#'
#' @return An S3 object of class "ConnectorLogger" containing:
#'   \itemize{
#'     \item An empty list
#'     \item Class attribute set to "ConnectorLogger"
#'   }
#'
#' @examples
#' logger <- ConnectorLogger
#' class(logger) # Returns "ConnectorLogger"
#' str(logger) # Shows empty list with class attribute
#'
#' @export
ConnectorLogger <- structure(list(), class = "ConnectorLogger")

#' Connector Logging Functions
#'
#' Generic functions and methods for logging connector operations including read,
#' write, remove, and list operations. These functions provide a consistent
#' logging interface across different connector types (FS, DBI, etc.).
#'
#' @section Generic Functions:
#' \describe{
#'   \item{\code{log_read_connector}}{Logs reading operations from connectors}
#'   \item{\code{log_write_connector}}{Logs writing operations to connectors}
#'   \item{\code{log_remove_connector}}{Logs removal operations on connectors}
#'   \item{\code{log_list_content_connector}}{Logs listing operations on connectors}
#' }
#'
#' @section Connector Types:
#' The logging functions have specific implementations for:
#' \itemize{
#'   \item ConnectorFS - File system connectors
#'   \item ConnectorDBI - Database connectors
#'   \item ConnectorLogger - Logger wrapper for any connector
#' }
#'
#' @param connector_object The connector object to log operations for
#' @param name The name/identifier of the connector or resource
#' @param ... Additional parameters passed to specific method implementations
#'
#' @return The result of the specific method implementation
#'
#' @examples
#' # Create a connector with logging
#' con <- connectors(test = connector_fs(tempdir()))
#' logged_con <- add_logs(con)
#' 
#' # Operations will be automatically logged
#' # log_read_connector(logged_con$test, "data.csv")
#' # log_write_connector(logged_con$test, "output.csv")
#'
#' @name log-functions
#' @rdname log-functions
#' @export
log_read_connector <- function(connector_object, name, ...) {
  UseMethod("log_read_connector")
}

#' @rdname log-functions
#' @export
log_read_connector.default <- function(connector_object, name, ...) {
  whirl::log_read(name)
}

#' Log Read Operation for ConnectorLogger class
#'
#' Implementation of the log_read_connector function for the ConnectorLogger
#'  class.
#'
#' @param connector_object The ConnectorLogger object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @rdname connector-logger-methods
#'
#' @return The result of the read operation.
#' @export
read_cnt.ConnectorLogger <- function(connector_object, name, ...) {
  res <- tryCatch(NextMethod())
  log_read_connector(connector_object, name, ...)
  return(res)
}


#' Log read operation for tbl method
#'
#' @rdname connector-logger-methods
#' @export
tbl_cnt.ConnectorLogger <- read_cnt.ConnectorLogger

#' @rdname log-functions
#' @export
log_write_connector <- function(connector_object, name, ...) {
  UseMethod("log_write_connector")
}

#' @rdname log-functions
#' @export
log_write_connector.default <- function(connector_object, name, ...) {
  whirl::log_write(name)
}

#' Log Write Operation for ConnectorLogger class
#'
#' Implementation of the log_write_connector function for the ConnectorLogger
#' class.
#'
#' @param connector_object The ConnectorLogger object.
#' @param x The data to write.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @name connector-logger-methods
#' @rdname connector-logger-methods
#' @return Invisible result of the write operation.
#' @export
write_cnt.ConnectorLogger <- function(connector_object, x, name, ...) {
  res <- tryCatch(NextMethod())
  log_write_connector(connector_object, name, ...)
  return(invisible(res))
}

#' @rdname log-functions
#' @export
log_remove_connector <- function(connector_object, name, ...) {
  UseMethod("log_remove_connector")
}

#' @rdname log-functions
#' @export
log_remove_connector.default <- function(connector_object, name, ...) {
  whirl::log_delete(name)
}

#' Log Remove Operation for ConnectorLogger class
#'
#' Implementation of the log_remove_connector function for the ConnectorLogger
#' class.
#'
#' @param connector_object The ConnectorLogger object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @rdname connector-logger-methods
#' @return The result of the remove operation.
#' @export
remove_cnt.ConnectorLogger <- function(connector_object, name, ...) {
  res <- tryCatch(NextMethod())
  log_remove_connector(connector_object, name, ...)
  return(invisible(res))
}

#' @rdname log-functions
#' @export
log_list_content_connector <- function(connector_object, ...) {
  UseMethod("log_list_content_connector")
}

#' List contents Operation for ConnectorLogger class
#'
#' Implementation of the log_read_connector function for the ConnectorLogger
#'  class.
#'
#' @param connector_object The ConnectorLogger object.
#' @param ... Additional parameters.
#'
#' @rdname connector-logger-methods
#' @return The result of the read operation.
#' @export
list_content_cnt.ConnectorLogger <- function(connector_object, ...) {
  res <- tryCatch(NextMethod())
  log_read_connector(connector_object, name = ".", ...)
  return(res)
}

#' Upload Operation for ConnectorLogger class
#'
#' Implementation of the upload_cnt function for the ConnectorLogger
#' class.
#'
#' @param connector_object The ConnectorLogger object.
#' @param file The file to upload.
#' @param name The name of the file in the connector.
#' @inheritParams connector-options-params
#' @param ... Additional parameters.
#'
#' @rdname connector-logger-methods
#' @return Invisible result of the upload operation.
#' @export
upload_cnt.ConnectorLogger <- function(
  connector_object,
  file,
  name = basename(file),
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
) {
  res <- tryCatch(NextMethod())
  log_write_connector(connector_object, name, ...)
  return(invisible(res))
}

#' Download Operation for ConnectorLogger class
#'
#' Implementation of the download_cnt function for the ConnectorLogger
#' class.
#'
#' @param connector_object The ConnectorLogger object.
#' @param name The name of the file in the connector.
#' @param file The local file path to download to.
#' @param ... Additional parameters.
#'
#' @rdname connector-logger-methods
#' @return The result of the download operation.
#' @export
download_cnt.ConnectorLogger <- function(
  connector_object,
  name,
  file = basename(name),
  ...
) {
  res <- tryCatch(NextMethod())
  log_read_connector(connector_object, name, ...)
  return(res)
}

#' Print Connector Logger
#'
#' This function prints the connector logger.
#'
#' @param x The connector logger object
#' @param ... Additional arguments
#'
#' @rdname connector-logger-methods
#' @return The result of the print operation
#'
#' @export
print.ConnectorLogger <- function(x, ...) {
  NextMethod()
}
