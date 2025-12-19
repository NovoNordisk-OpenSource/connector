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
#' @name connectors
NULL

#' @noRd
construct_connectors <- function(
  ...,
  .metadata = list(),
  .datasources = NULL
) {
  if (is.null(.datasources)) {
    cnts <- substitute(rlang::list2(...))
    .datasources <- connectors_to_datasources(cnts)
  }

  S7::new_object(
    .parent = list(...),
    metadata = .metadata,
    datasources = .datasources
  )
}

#' @noRd
validate_named <- function(x) {
  if (!rlang::is_named2(x)) {
    return("All elements must be named")
  }
}

#' @noRd
validate_unnamed <- function(x) {
  if (any(rlang::have_name(x))) {
    return("All elements must be not be named")
  }
}

#' @noRd
validate_connectors <- function(x) {
  if (!length(x)) {
    return("At least one Connector must be supplied")
  }

  if (
    !all(
      vapply(
        X = x,
        FUN = \(x) is_connector(x),
        FUN.VALUE = logical(1)
      )
    )
  ) {
    return("All elements must be a Connector object")
  }

  validate_named(x)
}

#' @noRd
prop_metadata <- S7::new_property(
  class = S7::class_list,
  getter = \(self) self@metadata,
  validator = \(value) validate_named(value)
)

#' @noRd
datasources <- S7::new_class(
  name = "datasources",
  parent = S7::class_list,
  validator = \(self) validate_unnamed(self)
)

#' @noRd
prop_datasources <- S7::new_property(
  class = datasources,
  getter = \(self) self@datasources
)

#' @rdname connectors
#' @export
connectors <- S7::new_class(
  name = "connectors",
  parent = S7::class_list,
  properties = list(
    metadata = prop_metadata,
    datasources = prop_datasources
  ),
  constructor = construct_connectors,
  validator = \(self) validate_connectors(self)
)

#' @noRd
S7::method(print, connectors) <- function(x, ...) {
  print_connectors(x, ...)
}

#' @noRd
S7::method(print, datasources) <- function(x, ...) {
  print_datasources(x, ...)
}

#' @noRd
is_connectors <- function(x) {
  S7::S7_inherits(x, connectors) |
    S7::S7_inherits(x, nested_connectors)
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

#' @noRd
print_datasources <- function(x, ...) {
  cli::cli_h1("Datasources")

  for (ds in x) {
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
