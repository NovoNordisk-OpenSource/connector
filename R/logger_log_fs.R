#' @rdname log-functions
#' @export
log_read_connector.ConnectorFS <- function(connector_object, name, ...) {
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_read(msg)
}

#' @rdname log-functions
#' @export
log_write_connector.ConnectorFS <- function(connector_object, name, ...) {
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_write(msg)
}

#' @rdname log-functions
#' @export
log_remove_connector.ConnectorFS <- function(connector_object, name, ...) {
  msg <- paste0(name, " @ ", connector_object$path)
  whirl::log_delete(msg)
}
