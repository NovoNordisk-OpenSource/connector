#' Log Read Operation for FS connector
#'
#' Implementation of the log_read_connector function for the connector_fs class.
#'
#' @param connector_object The connector_fs object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @export
log_read_connector.connector_fs <- function(connector_object, name, ...) {
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_read(msg)
}

#' Log Write Operation for FS connector
#'
#' Implementation of the log_write_connector function for the connector_fs
#' class.
#'
#' @param connector_object The connector_fs object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @export
log_write_connector.connector_fs <- function(connector_object, name, ...) {
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_write(msg)
}

#' Log Remove Operation for FS connector
#'
#' Implementation of the log_remove_connector function for the connector_fs
#' class.
#'
#' @param connector_object The connector_fs object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @export
log_remove_connector.connector_fs <- function(connector_object, name, ...) {
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_delete(msg)
}
