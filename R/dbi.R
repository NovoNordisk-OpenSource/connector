#' DBI connector
#'
#' @description
#' Connector object for DBI connections. This object is used to interact with DBI compliant database backends.
#' See the [DBI package](https://dbi.r-dbi.org/) for how which backends are supported.
#'
#' @param name [character] Table name
#'
#' @details
#' Upon garbage collection, the connection will try to disconnect from the database.
#' But it is good practice to call `disconnect` when you are done with the connection.
#'
#'
#' @name Connector_dbi_object
#'
#' @examples
#' # Create DBI connector
#'
#' db <- connector::Connector_dbi$new(RSQLite::SQLite(), ":memory:")
#'
#' db
#'
#' # Write to the database
#'
#' db$write(iris, "iris")
#'
#' # Read from the database
#'
#' db$read("iris") |>
#'   head(5)
#'
#' # List available tables
#'
#' db$list_content()
#'
#' # Use the connector to run a query
#'
#' db$get_conn() |>
#'   DBI::dbGetQuery("SELECT * FROM iris limit 5")
#'
#' # Use dplyr verbs and collect data
#'
#' db$tbl("iris") |>
#'   dplyr::filter(Sepal.Length > 7) |>
#'   dplyr::collect()
#'
#' # Disconnect from the database
#'
#' db$disconnect()
#'
#' @importFrom dplyr tbl
#' @importFrom DBI dbListTables dbDisconnect dbConnect dbWriteTable dbReadTable
#'
#' @export

Connector_dbi <- R6::R6Class(
  classname = "Connector_dbi",
  public = list(

    #' @description Initialize the connection
    #' @param drv DBI driver
    #' @param ... Additional arguments passed to [DBI::dbConnect]
    #' @return A [connector_dbi] object
    initialize = function(drv, ...) {
      private$conn <- DBI::dbConnect(drv = drv, ...)
    },

    #' @description List tables in the database
    #' @param ... Additional arguments passed to [DBI::dbListTables]
    #' @return A [character] vector of table names
    list_content = function(...) {
      DBI::dbListTables(conn = private$conn, ...)
    },

    #' @description Get the connection object
    #' @return A DBI connection object
    get_conn = function() {
      private$conn
    },

    #' @description Disconnect from the database
    disconnect = function() {
      DBI::dbDisconnect(conn = private$conn)
    },

    #' @description Read a table from the database
    #' @param ... Additional arguments passed to [DBI::dbReadTable]
    #' @return A [data.frame]
    read = function(name, ...) {
      DBI::dbReadTable(conn = private$conn, name = name, ...)
    },

    #' @description Write a table to the database
    #' @param x [data.frame] Table to write
    #' @param ... Additional arguments passed to [DBI::dbWriteTable]
    write = function(x, name, ...) {
      DBI::dbWriteTable(conn = private$conn, name = name, value = x, ...)
    },

    #' @description Create a [tbl] object
    #' @param ... Additional arguments passed to [dplyr::tbl]
    tbl = function(name, ...) {
      dplyr::tbl(src = private$conn, from = name, ...)
    }
  ),
  private = list(

    # Store the connection object
    conn = NULL,

    # Finalize the connection on garbage collection
    finalize = function() {
      self$disconnect()
    }
  ),
  cloneable = FALSE
)

#' Create DBI connector
#'
#' @description Create a new DBI connector object. See [Connector_dbi] for details.
#'
#' @param drv DBI driver. See [DBI::dbConnect] for details
#' @param ... Additional arguments passed to [DBI::dbConnect]
#' @param extra_class [character] Extra class added to the object. See details.
#' @return A new [connector_dbi] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the `connector_dbi` object.
#' This can be useful if you want to create a custom connection object for easier dispatch of new s3 methods,
#' while still inheriting the methods from the `connector_dbi` object.
#'
#' @examples
#' # Connect to in memory SQLite database
#'
#' db <- connector_dbi(RSQLite::SQLite(), ":memory:")
#'
#' db
#'
#' # Create subclass connection
#'
#' db_subclass <- connector_dbi(RSQLite::SQLite(), ":memory:", extra_class = "subclass")
#'
#' db_subclass
#' class(db_subclass)
#'
#' @export
#'
connector_dbi <- function(drv, ..., extra_class = NULL) {
  layer <- Connector_dbi$new(drv = drv, ...)
  if (!is.null(extra_class)) {
    extra_class <- paste(class(layer), extra_class, sep = "_")
    class(layer) <- c(extra_class, class(layer))
  }
  return(layer)
}
