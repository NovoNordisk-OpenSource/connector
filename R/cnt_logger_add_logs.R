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
#'   Each connection in the list will have the "ConnectorLogger" class
#'   prepended to its existing classes.
#'
#' @details
#' The function performs the following steps:
#' 1. Checks if the input `connections` is of class "connectors".
#' 1. Iterates through each connection in the list and prepends the "ConnectorLogger" class.
#'
#' @examples
#' con <- connectors(
#'   sdtm = connector_fs(path = tempdir())
#'  )
#'
#' logged_connections <- add_logs(con)
#'
#' @export
add_logs <- function(connections) {
  checkmate::assert_class(connections, "connectors")

  for (i in seq_along(connections)) {
    class(connections[[i]]) <- c("ConnectorLogger", class(connections[[i]]))
  }

  connections
}
