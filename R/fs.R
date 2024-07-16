#' Connector for file storage
#' @description
#' The connector_fs class is a file storage connector for accessing and manipulating files any file storage solution.
#' The default implementation includes methods for files stored on local or network drives.
#' @param name [character] Name of the content to read, write, or remove. Typically the table name.
#' @param x The object to write
#' @param file [character] The file to write or save to from the file storage.
#' @param ... Additional arguments passed to the method.
#' @importFrom R6 R6Class
#' @export
connector_fs <- R6::R6Class(
  classname = "connector_fs",
  inherit = connector,
  public = list(

    #' @description Initializes the connector_fs class
    #' @param path Path to the file storage
    #' @param access Access type ("rw" by default)
    initialize = function(path, access = "rw") {
      private$.path <- assert_path(path, access)
    },

    #' @description Read content
    #' @return The result of the read method
    download = function(name, file = basename(name), ...) {
      self %>%
        cnt_download(name, file, ...)
    },

    #' @description Upload a file
    #' @param x The object to upload to the file storage
    upload = function(file, name = basename(file), ...) {
      self %>%
        cnt_upload(file, name, ...)
    },

    #' @description Create a directory
    #' @param name The name of the directory to create
    #' @return The directory created
    create_directory = function(name, ...) {
      self %>%
        cnt_create_directory(name, ...)
    },

    #' @description Remove a directory
    #' @param name The name of the directory to create
    remove_directory = function(name, ...) {
      self %>%
        cnt_remove_directory(name, ...)
    }
  ),
  active = list(
    #' @field path Path to the file storage
    path = function() {
      private$.path
    }
  ),
  private = list(
    .path = character(0)
  )
)

#' Additional methods for file storage connectors
#' @description
#' These methods are additional S3 methods for  [connector_fs].
#' @seealso [connector_methods]
#' @param connector_object A [connector_fs] object to be able to use functions from it
#' @param ... Additional arguments passed to the methods
#' @name connector_fs_methods
NULL

#' Download method for connector object
#' @rdname connector_fs_methods
#' @export
cnt_download <- function(connector_object, ...) {
  UseMethod("cnt_download")
}

#' @export
cnt_download.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Upload method for connector object
#' @rdname connector_fs_methods
#' @export
cnt_upload <- function(connector_object, ...) {
  UseMethod("cnt_upload")
}

#' @export
cnt_upload.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Create directory method for connector object
#' @rdname connector_fs_methods
#' @export
cnt_create_directory <- function(connector_object, ...) {
  UseMethod("cnt_create_directory")
}

#' @export
cnt_create_directory.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Remove directory method for connector object
#' @rdname connector_fs_methods
#' @export
cnt_remove_directory <- function(connector_object, ...) {
  UseMethod("cnt_remove_directory")
}

#' @export
cnt_remove_directory.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Validate the path and access
#' @description
#' The assert_path function validates the path and access type for file system operations.
#' @param path Path to be validated
#' @param access Type of access ("rw" for read/write by default)
#' @return Invisible path
#' @importFrom checkmate makeAssertCollection assert_character assert_directory_exists reportAssertions
#' @noRd
assert_path <- function(path, access) {
  val <- checkmate::makeAssertCollection()

  checkmate::assert_character(
    x = path,
    len = 1,
    any.missing = FALSE,
    add = val
  )

  checkmate::assert_directory_exists(
    x = path,
    access = access,
    add = val
  )

  checkmate::reportAssertions(
    val
  )

  return(
    invisible(path)
  )
}
