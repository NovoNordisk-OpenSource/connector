#' Create `fs` connector
#'
#' @description
#' Initializes the connector for file system type of storage.
#' See [ConnectorFS] for details.
#'
#' @param path [character] Path to the file storage
#' @param extra_class `r rd_connector_utils("extra_class")`
#'
#' @return A new [ConnectorFS] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the
#' `ConnectorFS` object. This can be useful if you want to create
#' a custom connection object for easier dispatch of new s3 methods, while still
#' inheriting the methods from the `ConnectorFS` object.
#'
#' @examplesIf FALSE
#' # Create FS connector
#' cnt <- connector_fs(tempdir())
#' cnt
#'
#' # Create subclass connection
#' cnt_subclass <- connector_fs(
#'   path = tempdir(),
#'   extra_class = "subclass"
#' )
#' cnt_subclass
#' class(cnt_subclass)
#'
#' @export
connector_fs <- function(path, extra_class = NULL) {
  ConnectorFS$new(
    path = path,
    extra_class = extra_class
  )
}


#' Connector for file storage
#'
#' @description
#' The ConnectorFS class is a file storage connector for accessing and manipulating files any file storage solution.
#' The default implementation includes methods for files stored on local or network drives.
#'
#' @details
#' We recommend using the wrapper function [connector_fs()] to simplify the process of
#' creating an object of [ConnectorFS] class. It provides a more intuitive and user-friendly
#' approach to initialize the ConnectorFS class and its associated functionalities.
#'
#' @param name `r rd_connector_utils("name")`
#' @param x `r rd_connector_utils("x")`
#' @param file `r rd_connector_utils("file")`
#' @param ... `r rd_connector_utils("...")`
#' @param extra_class `r rd_connector_utils("extra_class")`
#'
#' @examples
#' # Create file storage connector
#' cnt <- ConnectorFS$new(tempdir())
#' cnt
#'
#' # You can do the same thing using wrapper function connector_fs()
#' cnt <- connector_fs(tempdir())
#' cnt
#'
#' # List content
#' cnt$list_content_cnt()
#'
#' # Write to the connector
#' cnt$write_cnt(iris, "iris.rds")
#'
#' # Check it is there
#' cnt$list_content_cnt()
#'
#' # Read the result back
#' cnt$read_cnt("iris.rds") |>
#'   head()
#'
#' @export
ConnectorFS <- R6::R6Class(
  classname = "ConnectorFS",
  inherit = Connector,
  public = list(
    #' @description
    #' Initializes the connector for file storage.
    #'
    #' @param path [character] Path to the file storage
    #' @param extra_class [character] Extra class to be added
    #' Checked using [checkmate::assert_directory_exists].
    initialize = function(path, extra_class = NULL) {
      private$.path <- path
      super$initialize(extra_class = extra_class)
    },

    #' @description
    #' Download content from the file storage.
    #' See also [download_cnt].
    #' @return [invisible] `file`
    download_cnt = function(name, file = basename(name), ...) {
      self |>
        download_cnt(name, file, ...)
    },

    #' @description
    #' Upload a file to the file storage.
    #' See also [upload_cnt].
    #' @return `r rd_connector_utils("inv_self")`
    upload_cnt = function(file, name = basename(file), ...) {
      self |>
        upload_cnt(file, name, ...)
    },

    #' @description
    #' Create a directory in the file storage.
    #' See also [create_directory_cnt].
    #' @param name [character] The name of the directory to create
    #' @return [ConnectorFS] object of a newly created directory
    create_directory_cnt = function(name, ...) {
      self |>
        create_directory_cnt(name, ...)
    },

    #' @description
    #' Remove a directory from the file storage.
    #' See also [remove_directory_cnt].
    #' @param name [character] The name of the directory to remove
    #' @return `r rd_connector_utils("inv_self")`
    remove_directory_cnt = function(name, ...) {
      self |>
        remove_directory_cnt(name, ...)
    },

    #' @description
    #' Use dplyr verbs to interact with the tibble.
    #' See also [tbl_cnt].
    #' @return A table object.
    tbl_cnt = function(name, ...) {
      self |>
        tbl_cnt(name, ...)
    }
  ),
  active = list(
    #' @field path [character] Path to the file storage
    path = function(value) {
      if (missing(value)) {
        private$.path
      } else {
        stop("Can't set `$path` field", call. = FALSE)
      }
    }
  ),
  private = list(
    .path = character(0)
  )
)
