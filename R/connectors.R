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

  if (!is.null(x$atasources) & !inherits(x$datasources, "cnts_datasources")) {
    cli::cli_abort("'datasources' is a reserved name. It cannot be used as a name for a data source.")
  }

  if (is.null(x$datasources)) {
    cnts <- substitute(rlang::list2(...))
    datasources <- connectors_to_datasources(cnts)
  } else {
    datasources <- as_datasources(x["datasources"])
  }

  checkmate::assert_list(x = x, names = "named")
  structure(
    x[names(x) != "datasources"],
    class = c("connectors"),
    datasources = datasources
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

#' @export
print.cnts_datasources <- function(x, ...) {
  cli::cli_h1("Datasources")

 for(ds in x[["datasources"]]) {
    cli::cli_h2(ds$name)
    cli::cli_ul()
    cli::cli_li("Backend Type: {.val {ds$backend$type}}")
    for (param_name in names(ds$backend)[names(ds$backend) != "type"]) {
      cli::cli_li("{param_name}: {.val {ds$backend[[param_name]]}}")
    }
    cli::cli_end()
    cli::cli_end()
  }

  x
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
#' # Assume we have a 'my_connectors' object with a 'datasources' attribute
#' my_connectors <- list()
#' attr(my_connectors, "datasources") <- list(source1 = "data1", source2 = "data2")
#'
#' # Using the function
#' result <- datasources(my_connectors)
#' print(result)
#'
#' @export
datasources <- function(connectors) {
  ds <- attr(connectors, "datasources")
  ds
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
