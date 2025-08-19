#' Create `fs` connector
#'
#' @description
#' Initializes the connector for file system type of storage.
#' See [ConnectorFS] for details.
#'
#' @param path [character] Path to the file storage.
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
#' @examples
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
#'
#' folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)
#'
#'
#'
#' cnt <- ConnectorFS$new(folder)
#' cnt
#'
#' # You can do the same thing using wrapper function connector_fs()
#' cnt <- connector_fs(folder)
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
    #' @param path [character] Path to the file storage.
    #' @param extra_class `r rd_connector_utils("extra_class")`
    initialize = function(path, extra_class = NULL) {
      private$.path <- path
      super$initialize(extra_class = extra_class)
    },

    #' @description
    #' Download content from the file storage.
    #' See also [download_cnt].
    #' @param src [character] The name of the file to download from the connector
    #' @param dest [character] Path to the file to download to
    #' @return `r rd_connector_utils("inv_connector")`
    download_cnt = function(src, dest = basename(src), ...) {
      self |>
        download_cnt(src, dest, ...)
    },

    #' @description
    #' Upload a file to the file storage.
    #' See also [upload_cnt].
    #' @param src [character] Path to the file to upload
    #' @param dest [character] The name of the file to create
    #' @return `r rd_connector_utils("inv_self")`
    upload_cnt = function(src, dest = basename(src), ...) {
      self |>
        upload_cnt(src, dest, ...)
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
    #' Upload a directory to the file storage.
    #' See also [upload_directory_cnt].
    #' @param src [character] The path to the directory to upload
    #' @param dest [character] The name of the directory to create
    #' @return `r rd_connector_utils("inv_self")`
    upload_directory_cnt = function(src, dest = basename(src), ...) {
      self |>
        upload_directory_cnt(src, dest, ...)
    },

    #' @description
    #' Download a directory from the file storage.
    #' See also [download_directory_cnt].
    #' @param src [character] The name of the directory to download from the connector
    #' @param dest [character] The path to the directory to download to
    #' @return `r rd_connector_utils("inv_connector")`
    download_directory_cnt = function(src, dest = basename(src), ...) {
      self |>
        download_directory_cnt(src, dest, ...)
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
