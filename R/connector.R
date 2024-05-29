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

  do.call(Connector, args)
}

#' A Connector object, a special list with R6 objects.
#' @param ... Arguments to pass to the connector
#' @export
Connector <- function(...) {
  structure(
    list(
      ...
    ),
    class = c("Connector")
  )
}
