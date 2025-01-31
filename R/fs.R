#' Connector for file storage
#'
#' @description
#' The connector_fs class is a file storage connector for accessing and manipulating files any file storage solution.
#' The default implementation includes methods for files stored on local or network drives.

#' @param name `r rd_connector_utils("name")`
#' @param x `r rd_connector_utils("x")`
#' @param file `r rd_connector_utils("file")`
#' @param ... `r rd_connector_utils("...")`
#' @param extra_class `r rd_connector_utils("extra_class")`
#'
#' @examples
#' # Create file storage connector
#'
#' cnt <- connector_fs$new(tempdir())
#'
#' cnt
#'
#' # List content
#'
#' cnt$list_content_cnt()
#'
#' # Write to the connector
#'
#' cnt$write_cnt(iris, "iris.rds")
#'
#' # Check it is there
#'
#' cnt$list_content_cnt()
#'
#' # Read the result back
#'
#' cnt$read_cnt("iris.rds") |>
#'   head()
#'
#' @export
connector_fs <- R6::R6Class(
  classname = "connector_fs",
  inherit = connector,
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
    #' @return [connector_fs] object of a newly created directory
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
    }
  ),
  active = list(
    #' @field path [character] Path to the file storage
    path = function() {
      private$.path
    }
  ),
  private = list(
    .path = character(0)
  )
)
