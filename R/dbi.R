#' Create `dbi` connector
#'
#' @description
#' Initializes the connector for DBI type of storage.
#' See [ConnectorDBI] for details.
#'
#' @param drv Driver object inheriting from [DBI::DBIDriver-class].
#' @param ... Additional arguments passed to [DBI::dbConnect()].
#' @param extra_class `r rd_connector_utils("extra_class")`
#'
#' @return A new [ConnectorDBI] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the
#' `ConnectorDBI` object. This can be useful if you want to create
#' a custom connection object for easier dispatch of new s3 methods, while still
#' inheriting the methods from the `ConnectorDBI` object.
#'
#' @examplesIf FALSE
#'
#' # Create DBI connector
#' cnt <- connector_dbi(RSQLite::SQLite(), ":memory:")
#' cnt
#'
#' # Create subclass connection
#' cnt_subclass <- connector_dbi(RSQLite::SQLite(), ":memory:",
#'   extra_class = "subclass"
#' )
#' cnt_subclass
#' class(cnt_subclass)
#'
#' @export
connector_dbi <- function(drv, ..., extra_class = NULL) {
  ConnectorDBI$new(
    drv = drv,
    ...,
    extra_class = extra_class
  )
}

#' Connector for DBI databases
#'
#' @description
#' Connector object for DBI connections. This object is used to interact with DBI compliant database backends.
#' See the [DBI package](https://dbi.r-dbi.org/) for which backends are supported.
#'
#' @param name `r rd_connector_utils("name")`
#' @param ... `r rd_connector_utils("...")`
#' @param extra_class `r rd_connector_utils("extra_class")`
#'
#' @details
#' We recommend using the wrapper function [connector_dbi()] to simplify the process of
#' creating an object of [ConnectorDBI] class. It provides a more intuitive and user-friendly
#' approach to initialize the ConnectorFS class and its associated functionalities.
#'
#' Upon garbage collection, the connection will try to disconnect from the database.
#' But it is good practice to call [disconnect_cnt] when you are done with the connection.
#'
#' @examples
#' # Create DBI connector
#' cnt <- ConnectorDBI$new(RSQLite::SQLite(), ":memory:")
#' cnt
#'
#' # You can do the same thing using wrapper function connector_dbi()
#' cnt <- connector_dbi(RSQLite::SQLite(), ":memory:")
#' cnt
#' # Write to the database
#' cnt$write_cnt(iris, "iris")
#'
#' # Read from the database
#' cnt$read_cnt("iris") |>
#'   head()
#'
#' # List available tables
#' cnt$list_content_cnt()
#'
#' # Use the connector to run a query
#' cnt$conn
#'
#' cnt$conn |>
#'   DBI::dbGetQuery("SELECT * FROM iris limit 5")
#'
#' # Use dplyr verbs and collect data
#' cnt$tbl_cnt("iris") |>
#'   dplyr::filter(Sepal.Length > 7) |>
#'   dplyr::collect()
#'
#' # Disconnect from the database
#' cnt$disconnect_cnt()
#'
#' @export
ConnectorDBI <- R6::R6Class(
  classname = "ConnectorDBI",
  inherit = Connector,
  public = list(
    #' @description
    #' Initialize the connection
    #' @param drv Driver object inheriting from [DBI::DBIDriver-class].
    #' @param ... Additional arguments passed to [DBI::dbConnect()].
    #' @param extra_class `r rd_connector_utils("extra_class")`
    initialize = function(drv, ..., extra_class = NULL) {
      if (!checkmate::check_class(drv, "DBIDriver")) {
        cli::cli_abort(
          "{.field drv} parameter has to be of type {.help [{.fun DBIDriver-class}](DBI::DBIDriver-class)}"
        )
      }
      private$.conn <- DBI::dbConnect(drv = drv, ...)
      super$initialize(extra_class = extra_class)
    },

    #' @description
    #' Disconnect from the database.
    #' See also [disconnect_cnt].
    #' @return [invisible] `self`.
    disconnect_cnt = function() {
      self |>
        disconnect_cnt()
    },

    #' @description
    #' Use dplyr verbs to interact with the remote database table.
    #' See also [tbl_cnt].
    #' @return A [dplyr::tbl] object.
    tbl_cnt = function(name, ...) {
      self |>
        tbl_cnt(name, ...)
    }
  ),
  active = list(
    #' @field conn The DBI connection. Inherits from [DBI::DBIConnector-class]
    conn = function(value) {
      if (missing(value)) {
        private$.conn
      } else {
        stop("Can't set `$conn` field", call. = FALSE)
      }
    }
  ),
  private = list(
    # Store the connection object
    .conn = NULL,

    # Finalize the connection on garbage collection
    finalize = function() {
      if (DBI::dbIsValid(dbObj = self$conn)) self$disconnect_cnt()
    }
  )
)
