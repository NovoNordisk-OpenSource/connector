#' Log Read Operation for FS connector
#'
#' Implementation of the log_read_connector function for the ConnectorFS class.
#'
#' @param connector_object The ConnectorFS object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @export
log_read_connector.ConnectorFS <- function(connector_object, name, ...) {
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_read(msg)
}

#' Log Write Operation for FS connector
#'
#' Implementation of the log_write_connector function for the ConnectorFS
#' class.
#'
#' @param connector_object The ConnectorFS object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @export
log_write_connector.ConnectorFS <- function(connector_object, name, ...) {
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_write(msg)
}

#' Log Remove Operation for FS connector
#'
#' Implementation of the log_remove_connector function for the ConnectorFS
#' class.
#'
#' @param connector_object The ConnectorFS object.
#' @param name The name of the connector.
#' @param ... Additional parameters.
#'
#' @export
log_remove_connector.ConnectorFS <- function(connector_object, name, ...) {
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_delete(msg)
}
