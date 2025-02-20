#' @description
#' * [ConnectorDBI]: Uses [DBI::dbReadTable()] to read the table from the DBI connection.
#'
#' @examples
#' # Read table from DBI database
#' cnt <- ConnectorDBI$new(RSQLite::SQLite())
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
read_cnt.ConnectorDBI <- function(connector_object, name, ...) {
  connector_object$conn |>
    DBI::dbReadTable(
      name = name,
      ...
    )
}

#' @description
#' * [ConnectorDBI]: Uses [DBI::dbWriteTable()] to write the table to the DBI connection.
#'
#' @param overwrite By default set to TRUE, in order to allow interchangeability between how
#' `ConnectorFS` works and `ConnectorDBI`.
#' @examples
#' # Write table to DBI database
#' cnt <- ConnectorDBI$new(RSQLite::SQLite())
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
write_cnt.ConnectorDBI <- function(
    connector_object,
    x,
    name,
    overwrite = TRUE,
    ...) {
  connector_object$conn |>
    DBI::dbWriteTable(
      name = name,
      value = x,
      overwrite = overwrite,
      ...
    )
  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorDBI]: Uses [DBI::dbListTables()] to list the tables in a DBI connection.
#'
#' @examples
#' # List tables in a DBI database
#' cnt <- ConnectorDBI$new(RSQLite::SQLite())
#'
#' cnt |>
#'   list_content_cnt()
#'
#' @rdname list_content_cnt
#' @export
list_content_cnt.ConnectorDBI <- function(
    connector_object,
    ...) {
  connector_object$conn |>
    DBI::dbListTables(
      ...
    )
}

#' @description
#' * [ConnectorDBI]: Uses [DBI::dbRemoveTable()] to remove the table from a DBI connection.
#'
#' @examples
#' # Remove table in a DBI database
#' cnt <- ConnectorDBI$new(RSQLite::SQLite())
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
remove_cnt.ConnectorDBI <- function(connector_object, name, ...) {
  connector_object$conn |>
    DBI::dbRemoveTable(
      name = name,
      ...
    )
  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorDBI]: Uses [dplyr::tbl()] to create a table reference to a table in a DBI connection.
#'
#' @examples
#' # Use dplyr verbs on a table in a DBI database
#' cnt <- ConnectorDBI$new(RSQLite::SQLite())
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
tbl_cnt.ConnectorDBI <- function(connector_object, name, ...) {
  connector_object$conn |>
    dplyr::tbl(
      from = name,
      ...
    )
}

#' @description
#' * [ConnectorDBI]: Uses [DBI::dbDisconnect()] to create a table reference to close a DBI connection.
#'
#' @examples
#' # Open and close a DBI connector
#' cnt <- ConnectorDBI$new(RSQLite::SQLite())
#'
#' cnt$conn
#'
#' cnt |>
#'   disconnect_cnt()
#'
#' cnt$conn
#' @rdname disconnect_cnt
#' @export
disconnect_cnt.ConnectorDBI <- function(connector_object, ...) {
  connector_object$conn |>
    DBI::dbDisconnect(
      ...
    )
}
