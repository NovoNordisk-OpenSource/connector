#' Collection of connector objects
#'
#' @description
#' Holds a special list of individual connector objects for consistent use of
#' connections in your project.
#'
#' @param ... Named individual [connector] objects
#'
#' @examples
#' # Create connectors objects
#'
#' con <- connectors(
#'   sdtm = connector_fs$new(path = tempdir()),
#'   adam = connector_dbi$new(drv = RSQLite::SQLite())
#' )
#'
#' # Print for overview
#'
#' con
#'
#' # Print the individual connector for more information
#'
#' con$sdtm
#'
#' con$adam
#'
#' @export
connectors <- function(...) {
  x <- rlang::list2(...)
  checkmate::assert_list(x = x, names = "named")
  structure(
    x,
    class = c("connectors")
  )
}

#' @export
print.connectors <- function(x, ...) {
  classes <- x |>
    lapply(\(x) class(x)[[1]]) |>
    unlist()

  classes <- glue::glue(
    "${{names(classes)}} {.cls {{classes}}}",
    .open = "{{", .close = "}}"
  ) |>
    as.character() |>
    rlang::set_names(" ")

  cli::cli_bullets(
    c(
      "{.cls {class(x)}}",
      classes
    )
  )
  return(invisible(x))
}
