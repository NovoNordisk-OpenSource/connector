#' Collection of connector objects
#'
#' @description
#' Holds a special list of individual connector objects for consistent use of
#' connections in your project.
#'
#' @param ... Named individual [Connector] objects
#'
#' @examples
#' # Create connectors objects
#'
#' cnts <- connectors(
#'   sdtm = connector_fs(path = tempdir()),
#'   adam = connector_dbi(drv = RSQLite::SQLite())
#' )
#'
#' # Print for overview
#'
#' cnts
#'
#' # Print the individual connector for more information
#'
#' cnts$sdtm
#'
#' cnts$adam
#'
#' @export
connectors <- function(...) {
  x <- rlang::list2(...)
  ds_ <- x[["datasources"]]

  md_ <- if (is.null(x[[".md"]])) list() else x[[".md"]]

  if (!is.null(ds_) && !inherits(ds_, "cnts_datasources")) {
    cli::cli_abort(
      "'datasources' is a reserved name. It cannot be used as a name for a data source."
    )
  }

  if (is.null(ds_)) {
    cnts <- substitute(rlang::list2(...))
    datasources <- connectors_to_datasources(cnts)
  } else {
    datasources <- ds_
  }

  checkmate::assert_list(x = x, names = "named")

  structure(
    x[!(names(x) %in% c("datasources", ".md"))],
    class = c("connectors"),
    datasources = datasources,
    metadata = md_
  )
}

#' @export
print.connectors <- function(x, ...) {
  print_connectors(x, ...)
}

#' @noRd
print_connectors <- function(x, ...) {
  classes <- x |>
    lapply(\(x) class(x)[[1]]) |>
    unlist()

  classes <- glue::glue(
    "${{names(classes)}} {.cls {{classes}}}",
    .open = "{{",
    .close = "}}"
  ) |>
    as.character() |>
    rlang::set_names(" ")

  bullets <- c("{.cls {class(x)}}", classes)

  # Add metadata if present
  metadata <- attr(x, "metadata")
  if (!is.null(metadata) && length(metadata) > 0) {
    metadata_lines <- metadata |>
      purrr::imap(\(value, name) {
        glue::glue(
          "<:cli::symbol$arrow_right:> <:name:>: {.val <:value:>}",
          .open = "<:",
          .close = ":>"
        )
      }) |>
      rlang::set_names(" ")

    bullets <- c(bullets, " " = "", " " = "Metadata:", metadata_lines)
  }

  cli::cli_bullets(bullets)
  return(invisible(x))
}

#' @export
print.cnts_datasources <- function(x, ...) {
  cli::cli_h1("Datasources")

  for (ds in x[["datasources"]]) {
    cli::cli_h2(ds$name)
    cli::cli_ul()
    cli::cli_li("Backend Type: {.val {ds$backend$type}}")
    for (param_name in names(ds$backend)[names(ds$backend) != "type"]) {
      cli::cli_li("{param_name}: {.val {ds$backend[[param_name]]}}")
    }
    cli::cli_end()
    cli::cli_end()
  }

  return(x)
}

#' @noRd
as_datasources <- function(...) {
  structure(
    ...,
    class = "cnts_datasources"
  )
}

#' Create a nested connectors object
#'
#' This function creates a nested connectors object from the provided arguments.
#'
#' @param ... Any number of connectors object.
#'
#' @return A list with class "nested_connectors" containing the provided arguments.
#' @export
nested_connectors <- function(...) {
  x <- rlang::list2(...)
  structure(
    x,
    class = c("nested_connectors")
  )
}

#' @export
print.nested_connectors <- function(x, ...) {
  print_connectors(x, ...)
}

#' @noRd
is_connectors <- function(connectors) {
  inherits(connectors, "connectors")
}
