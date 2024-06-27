#' Create FS connector
#'
#' @description Create a new FS connector object. See [Connector_fs] for details.
#'
#' @param path Path to the file system
#' @param ... Additional arguments passed to [Connector_fs]
#' @param extra_class [character] Extra class added to the object. See details.
#' @return A new [Connector_fs] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the `Connector_fs` object.
#' This can be useful if you want to create a custom connection object for easier dispatch of new s3 methods,
#' while still inheriting the methods from the `Connector_fs` object.
#'
#' @examples
#' # Connect to a file system
#'
#' path_to_adam <- system.file("demo_trial", "adam", package = "connector")
#' db <- connector_fs(path_to_adam)
#'
#' db
#'
#' # Create subclass connection
#'
#' db_subclass <- connector_fs(path_to_adam, extra_class = "subclass")
#'
#' db_subclass
#' class(db_subclass)
#'
#' @export
connector_fs <- function(path, ..., extra_class = NULL) {
  layer <- Connector_fs$new(path = path, ...)
  if (!is.null(extra_class)) {
    # TODO: not sure about paste and so on
    # extra_class <- paste(class(layer), extra_class, sep = "_")
    class(layer) <- c(extra_class, class(layer))
  }
  return(layer)
}

#' Class Connector_fs
#' @description The connector_fs class is a file system connector for accessing and manipulating files in a local file system.
#' @importFrom R6 R6Class
#'
#' @name Connector_fs_object
#' @export
Connector_fs <- R6::R6Class(
  "Connector_fs",
  public = list(
    #' @description Initializes the connector_fs class
    #' @param path Path to the file system
    #' @param access Access type ("rw" by default)
    initialize = function(path, access = "rw") {
      private$path <- assert_path(path, access)
    },
    #' @description Returns the list of files in the specified path
    #' @param ... Other parameters to pass to the list.files function
    list_content = function(...) {
      self %>%
        cnt_list_content(...)
    },
    #' @description Constructs a complete path by combining the specified access path with the provided elements
    #' @param ... Elements to construct the path
    construct_path = function(...) {
      file.path(private$path, ...)
    },
    #' @description Reads the content of the specified file using the private access path and additional options
    #' @param name Name of the file to read
    #' @param ... Other parameters to pass to the read_file function (depends on the extension of a file)
    read = function(name, ...) {
      self %>%
        cnt_read(name, ...)
    },
    #' @description Writes the specified content to the specified file using the private access path and additional options
    #' @param x Content to write to the file
    #' @param file File name
    #' @param ... Other parameters to pass to the write_file function (depends on the extension of a file)
    write = function(x, file, ...) {
      self %>%
        cnt_write(x = x, file = file, ...)
    },
    #' @description Remove the specified file by given name with extension
    #' @param file File name
    #'
    remove = function(file) {
      self %>%
        cnt_remove(file)
    },
    #' @description Returns the path of the file system
    #' @return Path to the file system
    get_path = function() {
      private$path
    }
  ),
  private = list(
    path = character(0)
  ),
  cloneable = TRUE
)


#' Validate the path and access
#'
#' @description The assert_path function validates the path and access type for file system operations.
#'
#' @param path Path to be validated
#' @param access Type of access ("rw" for read/write by default)
#'
#' @return Invisible path
#'
#' @export
#'
#' @importFrom checkmate makeAssertCollection assert_character assert_directory_exists reportAssertions
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
