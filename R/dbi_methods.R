#' @description
#' * [connector_dbi]: Uses [DBI::dbReadTable()] to read the table from the DBI connection.
#'
#' @examples
#' # Read table from DBI database
#' cnt <- connector_dbi$new(RSQLite::SQLite())
#'
#' cnt |>
#'   write_cnt(iris, "iris")
#'
#' cnt |>
#'   list_content_cnt()
#'
#' cnt |>
#'   read_cnt("iris") |>
#'   head()
#'
#' @rdname read_cnt
#' @export
read_cnt.connector_dbi <- function(connector_object, name, ...) {
  connector_object$conn |>
    DBI::dbReadTable(name = name, ...)
}

#' @description
#' * [connector_dbi]: Uses [DBI::dbWriteTable()] to write the table to the DBI connection.
#'
#' @examples
#' # Write table to DBI database
#' cnt <- connector_dbi$new(RSQLite::SQLite())
#'
#' cnt |>
#'   list_content_cnt()
#'
#' cnt |>
#'   write_cnt(iris, "iris")
#'
#' cnt |>
#'   list_content_cnt()
#'
#' @rdname write_cnt
#' @export
write_cnt.connector_dbi <- function(connector_object, x, name, ...) {
  connector_object$conn |>
    DBI::dbWriteTable(name = name, value = x, ...)
  return(invisible(connector_object))
}

#' @description
#' * [connector_dbi]: Uses [DBI::dbListTables()] to list the tables in a DBI connection.
#'
#' @examples
#' # List tables in a DBI database
#' cnt <- connector_dbi$new(RSQLite::SQLite())
#'
#' cnt |>
#'   list_content_cnt()
#'
#' @rdname list_content_cnt
#' @export
list_content_cnt.connector_dbi <- function(connector_object, ...) {
  connector_object$conn |>
    DBI::dbListTables(...)
}

#' @description
#' * [connector_dbi]: Uses [DBI::dbRemoveTable()] to remove the table from a DBI connection.
#'
#' @examples
#' # Remove table in a DBI database
#' cnt <- connector_dbi$new(RSQLite::SQLite())
#'
#' cnt |>
#'   write_cnt(iris, "iris") |>
#'   list_content_cnt()
#'
#' cnt |>
#'   remove_cnt("iris") |>
#'   list_content_cnt()
#'
#' @rdname remove_cnt
#' @export
remove_cnt.connector_dbi <- function(connector_object, name, ...) {
  connector_object$conn |>
    DBI::dbRemoveTable(name = name, ...)
  return(invisible(connector_object))
}

#' @description
#' * [connector_dbi]: Uses [dplyr::tbl()] to create a table reference to a table in a DBI connection.
#'
#' @examples
#' # Use dplyr verbs on a table in a DBI database
#' cnt <- connector_dbi$new(RSQLite::SQLite())
#'
#' iris_cnt <- cnt |>
#'   write_cnt(iris, "iris") |>
#'   tbl_cnt("iris")
#'
#' iris_cnt
#'
#' iris_cnt |>
#'   dplyr::collect()
#'
#' iris_cnt |>
#'   dplyr::group_by(Species) |>
#'   dplyr::summarise(
#'     n = dplyr::n(),
#'     mean.Sepal.Length = mean(Sepal.Length, na.rm = TRUE)
#'   ) |>
#'   dplyr::collect()
#'
#' @rdname tbl_cnt
#' @export
tbl_cnt.connector_dbi <- function(connector_object, name, ...) {
  connector_object$conn |>
    dplyr::tbl(from = name, ...)
}

#' @description
#' * [connector_dbi]: Uses [DBI::dbDisconnect()] to create a table reference to close a DBI connection.
#'
#' @examples
#' # Open and close a DBI connector
#' cnt <- connector_dbi$new(RSQLite::SQLite())
#'
#' cnt$conn
#'
#' cnt |>
#'   disconnect_cnt()
#'
#' cnt$conn
#' @rdname disconnect_cnt
#' @export
disconnect_cnt.connector_dbi <- function(connector_object, ...) {
  connector_object$conn |>
    DBI::dbDisconnect(...)
}
