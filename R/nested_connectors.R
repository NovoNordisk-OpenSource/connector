#' Create a nested connectors object
#'
#' This function creates a nested connectors object from the provided arguments.
#'
#' @param ... Any number of named [connectors()] objects.
#' @return A list with class "nested_connectors" containing the provided arguments.
#' @examples
#' nested_connectors(
#'   trial_1 = connectors(
#'     sdtm = connector_fs(path = tempdir())
#'   ),
#'   trial_2 = connectors(
#'     sdtm = connector_dbi(drv = RSQLite::SQLite())
#'   )
#' )
#'
#' @name nested_connectors
NULL

#' @noRd
construct_nested_connectors <- function(...) {
  S7::new_object(
    .parent = list(...)
  )
}

#' @noRd
validate_nested_connectors <- function(x) {
  if (!length(x)) {
    return("At least one connectors object must be supplied")
  }

  if (
    !all(
      vapply(
        X = x,
        FUN = \(x) is_connectors(x),
        FUN.VALUE = logical(1)
      )
    )
  ) {
    return("All elements must be a connectors object")
  }

  validate_named(x)
}

#' @rdname nested_connectors
#' @export
nested_connectors <- S7::new_class(
  name = "nested_connectors",
  parent = S7::class_list,
  constructor = construct_nested_connectors,
  validator = \(self) validate_nested_connectors(self)
)

#' @noRd
S7::method(print, nested_connectors) <- function(x, ...) {
  print_connectors(x, ...)
}
