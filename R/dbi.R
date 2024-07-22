#' R6 class for a dbi connection, see [connector_dbi] (used to interact with DBI compliant database backends)
#'
#' @description
#' Connector object for DBI connections. This object is used to interact with DBI compliant database backends.
#' See the [DBI package](https://dbi.r-dbi.org/) for how which backends are supported.
#'
#' @param name [character] Table name
#' @param extra_class [character] Extra class to assign to the new connector.
#'
#' @details
#' Upon garbage collection, the connection will try to disconnect from the database.
#' But it is good practice to call `disconnect` when you are done with the connection.
#'
#' @examples
#' # Create DBI connector
#'
#' db <- connector_dbi$new(RSQLite::SQLite(), ":memory:")
#'
#' db
#'
#' # Write to the database
#'
#' db$cnt_write(iris, "iris")
#'
#' # Read from the database
#'
#' db$cnt_read("iris") |>
#'   head(5)
#'
#' # List available tables
#'
#' db$cnt_list_content()
#'
#' # Use the connector to run a query
#'
#' db$conn
#'
#' db$conn |>
#'   DBI::dbGetQuery("SELECT * FROM iris limit 5")
#'
#' # Use dplyr verbs and collect data
#'
#' db$cnt_tbl("iris") |>
#'   dplyr::filter(Sepal.Length > 7) |>
#'   dplyr::collect()
#'
#' # Disconnect from the database
#'
#' db$cnt_disconnect()
#'
#' @importFrom dplyr tbl
#' @importFrom DBI dbListTables dbDisconnect dbConnect dbWriteTable dbReadTable
#' @export

connector_dbi <- R6::R6Class(
  classname = "connector_dbi",
  inherit = connector,
  public = list(

    #' @description Initialize the connection
    #' @param drv DBI driver
    #' @param ... Additional arguments passed to [DBI::dbConnect]
    #' @return A [connector_dbi] object
    initialize = function(drv, ..., extra_class = NULL) {
      private$.conn <- DBI::dbConnect(drv = drv, ...)
      super$initialize(extra_class = extra_class)
    },

    #' @description Disconnect from the database
    cnt_disconnect = function() {
      self %>%
        cnt_disconnect()
    },

    #' @description Create a [tbl] object
    #' @param ... Additional arguments passed to [dplyr::tbl]
    cnt_tbl = function(name, ...) {
      self %>%
        cnt_tbl(name, ...)
    }
  ),
  active = list(
    #' @field conn The DBI connector object of the connector
    conn = function() {
      private$.conn
    }
  ),
  private = list(

    # Store the connection object
    .conn = NULL,

    # Finalize the connection on garbage collection
    finalize = function() {
      if (DBI::dbIsValid(dbObj = self$conn)) self$cnt_disconnect()
    }
  )
)

#' Additional methods DBI connectors
#' @description
#' These methods are additional S3 methods for  [connector_dbi].
#' @seealso [connector_methods]
#' @param connector_object A [connector_dbi] object to be able to use functions from it
#' @param ... Additional arguments passed to the methods
#' @name connector_dbi_methods
NULL

#' disconnect method for connector object
#' @rdname connector_dbi_methods
#' @export
cnt_disconnect <- function(connector_object, ...) {
  UseMethod("cnt_disconnect")
}

#' @export
cnt_disconnect.default <- function(connector_object, ...) {
  method_error_msg()
}

#' tbl method for connector object
#' @rdname connector_dbi_methods
#' @export
cnt_tbl <- function(connector_object, ...) {
  UseMethod("cnt_tbl")
}

#' @export
cnt_tbl.default <- function(connector_object, ...) {
  method_error_msg()
}
