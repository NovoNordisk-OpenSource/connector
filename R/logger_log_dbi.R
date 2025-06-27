#' @rdname log-functions
#' @export
log_read_connector.ConnectorDBI <- function(connector_object, name, ...) {
  msg <- paste0(
    name,
    " @ ",
    "driver: ",
    class(connector_object$conn)[1],
    ", dbname: ",
    connector_object$conn@dbname
  )
  whirl::log_read(msg)
}

#' @rdname log-functions
#' @export
log_write_connector.ConnectorDBI <- function(connector_object, name, ...) {
  msg <- paste0(
    name,
    " @ ",
    "driver: ",
    class(connector_object$conn)[1],
    ", dbname: ",
    connector_object$conn@dbname
  )
  whirl::log_write(msg)
}

#' @rdname log-functions
#' @export
log_remove_connector.ConnectorDBI <- function(connector_object, name, ...) {
  msg <- paste0(
    name,
    " @ ",
    "driver: ",
    class(connector_object$conn)[1],
    ", dbname: ",
    connector_object$conn@dbname
  )
  whirl::log_delete(msg)
}
