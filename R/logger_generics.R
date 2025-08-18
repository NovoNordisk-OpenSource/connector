#' Create a New Connector Logger
#'
#' @title Create a New Connector Logger
#' @description Creates a new empty connector logger object of class
#' "ConnectorLogger".
#' This is an internal utility class that initializes a logging structure for
#' connector operations. Logs are added to connectors using [add_logs()].
#'
#' @param x object to print
#' @param ... parameters passed to the print method
#'
#' @return An S3 object of class "ConnectorLogger" containing:
#'   \itemize{
#'     \item An empty list
#'     \item Class attribute set to "ConnectorLogger"
#'   }
#'
#' @examples
#' logger <- ConnectorLogger
#' class(logger) # Returns "ConnectorLogger"
#' str(logger) # Shows empty list with class attribute
#'
#' @export
#' @name ConnectorLogger
ConnectorLogger <- structure(list(), class = "ConnectorLogger")

#' Connector Logging Functions
#'
#' @title Connector Logging Functions
#' @description
#' A comprehensive set of generic functions and methods for logging connector
#' operations. These functions provide automatic logging capabilities for read,
#' write, remove, and list operations across different connector types, enabling
#' transparent audit trails and operation tracking.
#'
#' @details
#' The logging system is built around S3 generic functions that dispatch to
#' specific implementations based on the connector class. Each operation is
#' logged with contextual information including connector details, operation
#' type, and resource names.
#'
#' @section Available Operations:
#' \describe{
#'   \item{\code{log_read_connector(connector_object, name, ...)}}{
#'     Logs read operations when data is retrieved from a connector.
#'     Automatically called by \code{read_cnt()} and \code{tbl_cnt()} methods.
#'   }
#'   \item{\code{log_write_connector(connector_object, name, ...)}}{
#'     Logs write operations when data is stored to a connector.
#'     Automatically called by \code{write_cnt()} and \code{upload_cnt()} methods.
#'   }
#'   \item{\code{log_remove_connector(connector_object, name, ...)}}{
#'     Logs removal operations when resources are deleted from a connector.
#'     Automatically called by \code{remove_cnt()} methods.
#'   }
#'   \item{\code{log_list_content_connector(connector_object, ...)}}{
#'     Logs listing operations when connector contents are queried.
#'     Automatically called by \code{list_content_cnt()} methods.
#'   }
#' }
#'
#' @section Supported Connector Types:
#' Each connector type has specialized logging implementations:
#' \describe{
#'   \item{\strong{ConnectorFS}}{
#'     File system connectors log the full file path and operation type.
#'     Example log: \code{"dataset.csv @ /path/to/data"}
#'   }
#'   \item{\strong{ConnectorDBI}}{
#'     Database connectors log driver information and database name.
#'     Example log: \code{"table_name @ driver: SQLiteDriver, dbname: mydb.sqlite"}
#'   }
#' }
#'
#' @section Integration with whirl Package:
#' All logging operations use the \pkg{whirl} package for consistent log output:
#' \itemize{
#'   \item \code{whirl::log_read()} - For read operations
#'   \item \code{whirl::log_write()} - For write operations
#'   \item \code{whirl::log_delete()} - For remove operations
#' }
#'
#' @param connector_object The connector object to log operations for. Can be
#'   any connector class (ConnectorFS, ConnectorDBI, ConnectorLogger, etc.)
#' @param name Character string specifying the name or identifier of the
#'   resource being operated on (e.g., file name, table name)
#' @param ... Additional parameters passed to specific method implementations.
#'   May include connector-specific options or metadata.
#'
#' @return
#' These are primarily side-effect functions that perform logging. The actual
#' return value depends on the specific method implementation, typically:
#' \itemize{
#'   \item \code{log_read_connector}: Result of the read operation
#'   \item \code{log_write_connector}: Invisible result of write operation
#'   \item \code{log_remove_connector}: Invisible result of remove operation
#'   \item \code{log_list_content_connector}: List of connector contents
#' }
#'
#' @examples
#' # Basic usage with file system connector
#' logged_fs <- add_logs(connectors(data = connector_fs(path = tempdir())))
#'
#' # Write operation (automatically logged)
#' write_cnt(logged_fs$data, mtcars, "cars.csv")
#' # Output: "cars.csv @ /tmp/RtmpXXX"
#'
#' #' # Read operation (automatically logged)
#' data <- read_cnt(logged_fs$data, "cars.csv")
#' # Output: "dataset.csv @ /tmp/RtmpXXX"
#'
#' # Database connector example
#' logged_db <- add_logs(connectors(db = connector_dbi(RSQLite::SQLite(), ":memory:")))
#'
#' # Operations are logged with database context
#' write_cnt(logged_db$db, iris, "iris_table")
#' # Output: "iris_table @ driver: SQLiteDriver, dbname: :memory:"
#'
#' @seealso
#' \code{\link{add_logs}} for adding logging capability to connectors,
#' \code{\link{ConnectorLogger}} for the logger class,
#' \pkg{whirl} package for underlying logging implementation
#'
#' @name log-functions
#' @rdname log-functions
#' @export
log_read_connector <- function(connector_object, name, ...) {
  UseMethod("log_read_connector")
}

#' @rdname log-functions
#' @export
log_read_connector.default <- function(connector_object, name, ...) {
  whirl::log_read(name)
}

#' @description
#' * [ConnectorLogger]: Logs the read operation and calls the underlying connector method.
#'
#' @examples
#' # Add logging to a file system connector
#' folder <- withr::local_tempdir("test", clean = FALSE)
#'
#' cnt <- connectors(data = connector_fs(folder)) |> add_logs()
#'
#' cnt$data |>
#'   write_cnt(iris, "iris.csv")
#'
#' cnt$data |>
#'   read_cnt("iris.csv", show_col_types = FALSE) |>
#'   head()
#'
#' @rdname read_cnt
#' @export
read_cnt.ConnectorLogger <- function(connector_object, name, ...) {
  res <- tryCatch(NextMethod())
  log_read_connector(connector_object, name, ...)
  return(res)
}


#' @rdname tbl_cnt
#' @export
tbl_cnt.ConnectorLogger <- read_cnt.ConnectorLogger

#' @rdname log-functions
#' @export
log_write_connector <- function(connector_object, name, ...) {
  UseMethod("log_write_connector")
}

#' @rdname log-functions
#' @export
log_write_connector.default <- function(connector_object, name, ...) {
  whirl::log_write(name)
}

#' @description
#' * [ConnectorLogger]: Logs the write operation and calls the underlying connector method.
#'
#' @examples
#' # Add logging to a database connector
#' cnt <- connectors(data = connector_dbi(RSQLite::SQLite())) |> add_logs()
#'
#' cnt$data |>
#'   write_cnt(mtcars, "cars")
#'
#' @rdname write_cnt
#' @export
write_cnt.ConnectorLogger <- function(connector_object, x, name, ...) {
  res <- tryCatch(NextMethod())
  log_write_connector(connector_object, name, ...)
  return(invisible(res))
}

#' @rdname log-functions
#' @export
log_remove_connector <- function(connector_object, name, ...) {
  UseMethod("log_remove_connector")
}

#' @rdname log-functions
#' @export
log_remove_connector.default <- function(connector_object, name, ...) {
  whirl::log_delete(name)
}

#' @description
#' * [ConnectorLogger]: Logs the remove operation and calls the underlying connector method.
#'
#' @examples
#' # Add logging to a connector and remove content
#' folder <- withr::local_tempdir("test", clean = FALSE)
#'
#' cnt <- connectors(data = connector_fs(folder)) |> add_logs()
#'
#' cnt$data |>
#'   write_cnt(iris, "iris.csv")
#'
#' cnt$data |>
#'   remove_cnt("iris.csv")
#'
#' @rdname remove_cnt
#' @export
remove_cnt.ConnectorLogger <- function(connector_object, name, ...) {
  res <- tryCatch(NextMethod())
  log_remove_connector(connector_object, name, ...)
  return(invisible(res))
}

#' @rdname log-functions
#' @export
log_list_content_connector <- function(connector_object, ...) {
  UseMethod("log_list_content_connector")
}

#' @description
#' * [ConnectorLogger]: Logs the list operation and calls the underlying connector method.
#'
#' @examples
#' # Add logging to a connector and list contents
#' folder <- withr::local_tempdir("test", clean = FALSE)
#'
#' cnt <- connectors(data = connector_fs(folder)) |> add_logs()
#'
#' cnt$data |>
#'   write_cnt(iris, "iris.csv")
#'
#' cnt$data |>
#'   list_content_cnt()
#'
#' @rdname list_content_cnt
#' @export
list_content_cnt.ConnectorLogger <- function(connector_object, ...) {
  res <- tryCatch(NextMethod())
  log_read_connector(connector_object, name = ".", ...)
  return(res)
}

#' @description
#' * [ConnectorLogger]: Logs the upload operation and calls the underlying connector method.
#'
#' @examples
#' # Add logging to a file system connector for uploads
#' folder <- withr::local_tempdir("test", clean = FALSE)
#'
#' cnt <- connectors(data = connector_fs(folder)) |> add_logs()
#'
#' # Create a temporary file
#' temp_file <- tempfile(fileext = ".csv")
#' write.csv(iris, temp_file, row.names = FALSE)
#'
#' cnt$data |>
#'   upload_cnt(temp_file, "uploaded_iris.csv")
#'
#' @rdname upload_cnt
#' @export
upload_cnt.ConnectorLogger <- function(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
) {
  res <- tryCatch(NextMethod())
  log_write_connector(connector_object, dest, ...)
  return(
    invisible(res)
  )
}

#' @description
#' * [ConnectorLogger]: Logs the download operation and calls the underlying connector method.
#'
#' @examples
#' # Add logging to a file system connector for downloads
#' folder <- withr::local_tempdir("test", clean = FALSE)
#'
#' cnt <- connectors(data = connector_fs(folder)) |> add_logs()
#'
#' cnt$data |>
#'   write_cnt(iris, "iris.csv")
#'
#' cnt$data |>
#'   download_cnt("iris.csv", tempfile(fileext = ".csv"))
#'
#' @rdname download_cnt
#' @export
download_cnt.ConnectorLogger <- function(
  connector_object,
  src,
  dest = basename(src),
  ...
) {
  res <- tryCatch(NextMethod())
  log_read_connector(connector_object, src, ...)
  return(
    invisible(res)
  )
}

#' @rdname ConnectorLogger
#' @export
print.ConnectorLogger <- function(x, ...) {
  NextMethod()
}
