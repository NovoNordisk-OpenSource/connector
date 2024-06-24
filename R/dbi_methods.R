#' Read a table from the database
#' @param connector_object Connector_dbi object
#' @param name Table name
#' @param ... Additional arguments passed to [DBI::dbReadTable]
#'
#' @return A [data.frame]
#'
#' @export
#'
#' @examples
#' connector <- Connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
#'
#' connector$read("iris")
#'
read.Connector_dbi <- function(connector_object, name, ...) {
    connector_object$get_conn() %>%
        DBI::dbReadTable(name = name, ...)
}


#' Write a table to the database
#' @param connector_object Connector_dbi object
#' @param x Table to write
#' @param name Table name
#' @param ... Additional arguments passed to [DBI::dbWriteTable]
#' @export
#'
#' @examples
#' connector <- Connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
write.Connector_dbi <- function(connector_object, x, name, ...) {
    connector_object$get_conn() %>%
        DBI::dbWriteTable(name = name, value = x, ...)
}

#' List tables in the database
#' @param connector_object Connector_dbi object
#' @param ... Additional arguments passed to [DBI::dbListTables]
#' @return A [character] vector of table names
#' @export
#' @examples
#' connector <- Connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
#' connector$list_content()
list_content.Connector_dbi <- function(connector_object, ...) {
    connector_object$get_conn() %>%
        DBI::dbListTables(...)
}

#' Remove a table from the database
#' @param connector_object Connector_dbi object
#' @param name Table name
#' @param ... Additional arguments passed to [DBI::dbRemoveTable]
#' @export
#' @examples
#' connector <- Connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
#' connector$remove("iris")
remove.Connector_dbi <- function(connector_object, name, ...) {
    connector_object$get_conn() %>%
        DBI::dbRemoveTable(name = name, ...)
}

#' Create a [tbl] object
#' @param connector_object Connector_dbi object
#' @param name Table name
#' @param ... Additional arguments passed to [dplyr::tbl]
#' @export
#' @examples
#' connector <- Connector_dbi$new(RSQLite::SQLite())
#' connector$write(iris, "iris")
#' connector$tbl("iris")
tbl.Connector_dbi <- function(connector_object, name, ...) {
    connector_object$get_conn() %>%
        dplyr::tbl(from = name, ...)
}

#' Disconnect from the database
#' @param connector_object Connector_dbi object
#' @param ... Additional arguments passed to [DBI::dbDisconnect]
#' @export
#' @examples
#' connector <- Connector_dbi$new(RSQLite::SQLite())
#' connector$disconnect()
disconnect.Connector_dbi <- function(connector_object, ...) {
    connector_object$get_conn() %>%
        DBI::dbDisconnect(...)
}
