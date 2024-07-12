#' Connector for file system
#' @description
#' The connector_fs class is a file system connector for accessing and manipulating files in a local file system.
#' @importFrom R6 R6Class
#' @export
connector_fs <- R6::R6Class(
  classname = "connector_fs",
  inherit = connector,
  public = list(
    #' @description Initializes the connector_fs class
    #' @param path Path to the file system
    #' @param access Access type ("rw" by default)
    initialize = function(path, access = "rw") {
      private$.path <- assert_path(path, access)
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
