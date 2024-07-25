#' Connector for DBI databases
#'
#' @description
#' Connector object for DBI connections. This object is used to interact with DBI compliant database backends.
#' See the [DBI package](https://dbi.r-dbi.org/) for which backends are supported.
#'
#' @param name `r rd_connector_params("name")`
#' @param ... `r rd_connector_params("...")`
#' @param extra_class `r rd_connector_params("extra_class")`
#'
#' @details
#' Upon garbage collection, the connection will try to disconnect from the database.
#' But it is good practice to call [cnt_disconnect] when you are done with the connection.
#'
#' @examples
#' # Create DBI connector
#'
#' cnt <- connector_dbi$new(RSQLite::SQLite(), ":memory:")
#'
#' cnt
#'
#' # Write to the database
#'
#' cnt$cnt_write(iris, "iris")
#'
#' # Read from the database
#'
#' cnt$cnt_read("iris") |>
#'   head(5)
#'
#' # List available tables
#'
#' cnt$cnt_list_content()
#'
#' # Use the connector to run a query
#'
#' cnt$conn
#'
#' cnt$conn |>
#'   DBI::dbGetQuery("SELECT * FROM iris limit 5")
#'
#' # Use dplyr verbs and collect data
#'
#' cnt$cnt_tbl("iris") |>
#'   dplyr::filter(Sepal.Length > 7) |>
#'   dplyr::collect()
#'
#' # Disconnect from the database
#'
#' cnt$cnt_disconnect()
#'
#' @export

connector_dbi <- R6::R6Class(
  classname = "connector_dbi",
  inherit = connector,
  public = list(

    #' @description
    #' Initialize the connection
    #' @param drv Driver object inheriting from [DBI::DBIDriver-class].
    #' @param ... Additional arguments passed to [DBI::dbConnect].
    initialize = function(drv, ..., extra_class = NULL) {
      private$.conn <- DBI::dbConnect(drv = drv, ...)
      super$initialize(extra_class = extra_class)
    },

    #' @description
    #' Disconnect from the database.
    #' See also [cnt_disconnect].
    #' @return [invisible] `self`.
    cnt_disconnect = function() {
      self %>%
        cnt_disconnect()
    },

    #' @description
    #' Use dplyr verbs to interact with the remote database table.
    #' See also [cnt_tbl].
    #' @return A [dplyr::tbl] object.
    cnt_tbl = function(name, ...) {
      self %>%
        cnt_tbl(name, ...)
    }
  ),
  active = list(
    #' @field conn The DBI connection. Inherits from [DBI::DBIConnector-class]
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
