#' Collection of connector objects
#'
#' @description
#' Holds a special list of individual connector objects for consistent use of
#' connections in your project.
#'
#' @param ... Named individual [connector] objects
#' @param datasources [list] of information for datasources from the connect function. By default NULL, only used with connect
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
  if(is.null(x$datasources)){
    cnts <- substitute(list(...))
    datasources <- connectors_to_datasources(cnts)
  }else{
    datasources <- x$datasources
  }
  datasources <- structure(datasources, class = "cnts_datasources")
  checkmate::assert_list(x = x, names = "named")
  structure(
    x[names(x) != "datasources"],
    class = c("connectors"),
    datasources = datasources
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

#' @export
print.cnts_datasources <- function(x, ...) {
  cli::cli_h1("Datasources")
  
  for (ds in x$datasources) {
    cli::cli_h2(ds$name)
    cli::cli_ul()
    cli::cli_li("Backend Type: {.val {ds$backend$type}}")
    for (param_name in names(ds$backend)[names(ds$backend) != "type"]) {
      cli::cli_li("{param_name}: {.val {ds$backend[[param_name]]}}")
    }
    cli::cli_end()
  }
}

datasources <- function(connectors){
  ds <- attr(connectors, "datasources")
  ds
}
