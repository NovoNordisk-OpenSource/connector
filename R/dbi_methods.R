#' Read a table from the database
#' @param connector_object connector_dbi object
#' @param name Table name
#' @param ... Additional arguments passed to [DBI::dbReadTable]
#'
#' @return A [data.frame]
#'
#' @export
#'
#' @examples
#' connector <- connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
#'
#' connector$read("iris")
#'
cnt_read.connector_dbi <- function(connector_object, name, ...) {
  connector_object$get_conn() %>%
    DBI::dbReadTable(name = name, ...)
}


#' Write a table to the database
#' @param connector_object connector_dbi object
#' @param x Table to write
#' @param name Table name
#' @param ... Additional arguments passed to [DBI::dbWriteTable]
#' @export
#'
#' @examples
#' connector <- connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
cnt_write.connector_dbi <- function(connector_object, x, name, ...) {
  connector_object$get_conn() %>%
    DBI::dbWriteTable(name = name, value = x, ...)
}

#' List tables in the database
#' @param connector_object connector_dbi object
#' @param ... Additional arguments passed to [DBI::dbListTables]
#' @return A [character] vector of table names
#' @export
#' @examples
#' connector <- connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
#' connector$list_content()
cnt_list_content.connector_dbi <- function(connector_object, ...) {
  connector_object$get_conn() %>%
    DBI::dbListTables(...)
}

#' Remove a table from the database
#' @param connector_object connector_dbi object
#' @param name Table name
#' @param ... Additional arguments passed to [DBI::dbRemoveTable]
#' @export
#' @examples
#' connector <- connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
#' connector$remove("iris")
cnt_remove.connector_dbi <- function(connector_object, name, ...) {
  connector_object$get_conn() %>%
    DBI::dbRemoveTable(name = name, ...)
}

#' Create a [tbl] object
#' @param connector_object connector_dbi object
#' @param name Table name
#' @param ... Additional arguments passed to [dplyr::tbl]
#' @export
#' @examples
#' connector <- connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
#' connector$tbl("iris")
cnt_tbl.connector_dbi <- function(connector_object, name, ...) {
  connector_object$get_conn() %>%
    dplyr::tbl(from = name, ...)
}

#' Disconnect from the database
#' @param connector_object connector_dbi object
#' @param ... Additional arguments passed to [DBI::dbDisconnect]
#' @export
#' @examples
#' connector <- connector_dbi$new(RSQLite::SQLite())
#' connector$disconnect()
cnt_disconnect.connector_dbi <- function(connector_object, ...) {
  connector_object$get_conn() %>%
    DBI::dbDisconnect(...)
}
