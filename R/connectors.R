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
#' con <- connectors(
#'   sdtm = connector_fs(path = tempdir()),
#'   adam = connector_dbi(drv = RSQLite::SQLite())
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

  cli::cli_bullets(
    c(
      "{.cls {class(x)}}",
      classes
    )
  )
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

#' Extract data sources from connectors
#'
#' This function extracts the "datasources" attribute from a connectors object.
#'
#' @param connectors An object containing connectors with a "datasources" attribute.
#'
#' @return An object containing the data sources extracted from the "datasources" attribute.
#'
#' @details
#' The function uses the `attr()` function to access the "datasources" attribute
#' of the `connectors` object. It directly returns this attribute without any
#' modification.
#'
#' @examples
#' # Assume we have a 'mock_connectors' object with a 'datasources' attribute
#' mock_connectors <- structure(list(), class = "connectors")
#' attr(mock_connectors, "datasources") <- list(source1 = "data1", source2 = "data2")
#'
#' # Using the function
#' result <- datasources(mock_connectors)
#' print(result)
#'
#' @export
datasources <- function(connectors) {
  if (!is_connectors(connectors)) {
    cli::cli_abort("param connectors should be a connectors object.")
  }

  ds <- attr(connectors, "datasources")
  ds
}

#' Extract metadata from connectors
#'
#' This function extracts the "metadata" attribute from a connectors object,
#' with optional filtering to return only a specific metadata field.
#'
#' @param connectors An object containing connectors with a "metadata" attribute.
#' @param attr A character string specifying which metadata attribute to extract.
#'   If `NULL` (default), returns all metadata.
#'
#' @return A list containing the metadata extracted from the "metadata" attribute,
#'   or the specific attribute value if `attr` is specified.
#'
#' @examples
#' # Assume we have a 'mock_connectors' object with a 'metadata' attribute
#' mock_connectors <- structure(list(), class = "connectors")
#' attr(mock_connectors, "metadata") <- list(study = "demo", version = "1.0")
#'
#' # Extract all metadata
#' result <- extract_metadata(mock_connectors)
#' print(result)
#'
#' # Extract specific metadata field
#' study_name <- extract_metadata(mock_connectors, attr = "study")
#' print(study_name)
#'
#' @export
extract_metadata <- function(connectors, attr = NULL) {
  if (!is_connectors(connectors)) {
    cli::cli_abort("param connectors should be a connectors object.")
  }

  metadata <- attr(connectors, "metadata")

  if (!is.null(attr)) {
    metadata <- metadata[[attr]]
  }

  metadata
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
