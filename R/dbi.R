#' R6 class for a dbi connection, see [connector_dbi] (used to interact with DBI compliant database backends)
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
#' db <- Connector_dbi$new(RSQLite::SQLite(), ":memory:")
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
  inherit = Connector,
  public = list(

    #' @description Initialize the connection
    #' @param drv DBI driver
    #' @param ... Additional arguments passed to [DBI::dbConnect]
    #' @return A [connector_dbi] object
    initialize = function(drv, ...) {
      private$conn <- DBI::dbConnect(drv = drv, ...)
    },

    #' @description Get the connection object
    #' @return A DBI connection object
    get_conn = function() {
      private$conn
    },

    #' @description Disconnect from the database
    disconnect = function() {
      self %>%
        cnt_disconnect()
    },

    #' @description Create a [tbl] object
    #' @param ... Additional arguments passed to [dplyr::tbl]
    tbl = function(name, ...) {
      self %>%
        cnt_tbl(name, ...)
    }
  ),
  private = list(

    # Store the connection object
    conn = NULL,

    # Finalize the connection on garbage collection
    finalize = function() {
      if (DBI::dbIsValid(dbObj = private$conn)) self$disconnect()
    }
  )
)

#' Create a new DBI connector object to interact with DBI compliant database backends
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
    # TODO: not sure about paste and so on
    # extra_class <- paste(class(layer)[1], extra_class, sep = "_")
    class(layer) <- c(extra_class, class(layer))
  }
  return(layer)
}

#' disconnect method for connector object
#' @name connector_dbi_methods
#' @export
cnt_disconnect <- function(connector_object, ...) {
  UseMethod("cnt_disconnect")
}

#' @export
cnt_disconnect.default <- function(connector_object, ...) {
  stop("Method not implemented")
}

#' tbl method for connector object
#' @rdname connector_dbi_methods
#' @export
cnt_tbl <- function(connector_object, ...) {
  UseMethod("cnt_tbl")
}

#' @export
cnt_tbl.default <- function(connector_object, ...) {
  stop("Method not implemented")
}
