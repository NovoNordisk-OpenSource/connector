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

#' Log Read Connector
#'
#' This function is a generic for logging the reading of a connector object. The
#' actual implementation of the logging is determined by the specific method for
#' the connector object's class.
#'
#' @param connector_object The connector object to log the reading of.
#' @param name The name of the connector.
#' @param ... Additional parameters passed to the specific method implementation
#'
#' @return The result of the specific method implementation.
#' @export
log_read_connector <- function(connector_object, name, ...) {
  UseMethod("log_read_connector")
}

#' Default Log Read Operation
#'
#' Default implementation of the log_read_connector function.
#'
#' @param connector_object The connector object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
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
#' @return The result of the read operation.
#' @export
read_cnt.ConnectorLogger <- function(connector_object, name, ...) {
  res <- tryCatch(NextMethod())
  log_read_connector(connector_object, name, ...)
  return(res)
}

#' Log Write Connector
#'
#' This function is a generic for logging the writing of a connector object. The
#' actual implementation of the logging is determined by the specific method for
#' the connector object's class.
#'
#' @param connector_object The connector object to log the writing of.
#' @param name The name of the connector.
#' @param ... Additional parameters passed to the specific method implementation
#'
#' @return The result of the specific method implementation.
#' @export
log_write_connector <- function(connector_object, name, ...) {
  UseMethod("log_write_connector")
}

#' Default Log Write Operation
#'
#' Default implementation of the log_write_connector function.
#'
#' @param connector_object The connector object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
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
#' @return Invisible result of the write operation.
#' @export
write_cnt.ConnectorLogger <- function(connector_object, x, name, ...) {
  res <- tryCatch(NextMethod())
  log_write_connector(connector_object, name, ...)
  return(invisible(res))
}

#' Log Remove Connector
#'
#' This function is a generic for logging the removal of a connector object. The
#' actual implementation of the logging is determined by the specific method for
#' the connector object's class.
#'
#' @param connector_object The connector object to log the removal of.
#' @param name The name of the connector.
#' @param ... Additional parameters passed to the specific method implementation
#'
#' @return The result of the specific method implementation.
#' @export
log_remove_connector <- function(connector_object, name, ...) {
  UseMethod("log_remove_connector")
}

#' Default Log Remove Operation
#'
#' Default implementation of the log_remove_connector function.
#'
#' @param connector_object The connector object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
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
#' @return The result of the remove operation.
#' @export
remove_cnt.ConnectorLogger <- function(connector_object, name, ...) {
  res <- tryCatch(NextMethod())
  log_remove_connector(connector_object, name, ...)
  return(invisible(res))
}

#' List contents
#'
#' This function is a generic for logging the List contents of a
#' connector object. The actual implementation of the logging is determined by
#' the specific method for the connector object's class.
#'
#' @param connector_object The connector object to log the List contents of.
#' @param ... Additional parameters passed to the specific method implementation
#'
#' @return The result of the specific method implementation.
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
#' @param overwrite Whether to overwrite existing files.
#' @param ... Additional parameters.
#'
#' @return Invisible result of the upload operation.
#' @export
upload_cnt.ConnectorLogger <- function(connector_object, ...) {
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
#' @return The result of the download operation.
#' @export
download_cnt.ConnectorLogger <- function(connector_object, name, ...) {
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
#' @return The result of the print operation
#'
#' @export
print.ConnectorLogger <- function(x, ...) {
  NextMethod()
}
