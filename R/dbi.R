#' Create DBI connector
#' @param drv DBI driver
#' @param ... Additional arguments passed to [DBI::dbConnect]
#' @return A new [connector_dbi] object
#' @export

connect_dbi <- function(drv, ...) {
  connector_dbi$new(drv = drv, ...)
}

#' DBI connection
#' @description
#' A short description...
#' @param name [character] Table name
#' @export

connector_dbi <- R6::R6Class(
  classname = "connector_dbi",
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

    #' @description Create a tbl object
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
      DBI::dbDisconnect(conn = private$conn)
    }
  ),
  cloneable = FALSE
)

