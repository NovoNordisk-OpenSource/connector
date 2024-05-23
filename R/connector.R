#' Connect to a database
#' @param yaml A yaml file with the connection information
#' @param ... Arguments to pass to the connector
#' @return A new connector object
#' @export

connect <- function(yaml = NULL, ...) {
  args <- rlang::list2(...)

  if (!is.null(yaml)) {
    args <- yaml::read_yaml(yaml) |>
      c(args)
  }

  do.call(connector_$new, args)
}

#' R6 general connector class
#' @export
connector_ <- R6::R6Class("connector_")
