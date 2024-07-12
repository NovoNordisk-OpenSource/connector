#' Read files for the connector_fs class
#' @export
#' @param connector_object A connector_fs object
#' @param name Name of the file to read
#' @param ... Other parameters to pass to the read_file function (depends on the extension of a file)
#'
#' @examples
#' connector <- connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$read("iris.csv")
#' connector$remove("iris.csv")
cnt_read.connector_fs <- function(connector_object, name, ...) {
  name |>
    find_file(root = connector_object$path) |>
    read_file(...)
}

#' Write a file based on this extension
#' @export
#'
#' @param connector_object A connector_fs object
#' @param x Object to write
#' @param file Path to write the file
#' @param ... Other parameters for write's functions
#'
#' @examples
#' connector <- connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$remove("iris.csv")
#'
cnt_write.connector_fs <- function(connector_object, x, file, ...) {
  file <- file.path(connector_object$path, file)
  write_file(x, file, ...)
}

#' List content of the directory
#' @param ... Arguments to pass to the list.files function
#' @param connector_object connector_fs object
#' @export
#' @examples
#' connector <- connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$list_content()
cnt_list_content.connector_fs <- function(connector_object, ...) {
  connector_object$path %>%
    list.files(...)
}

#' Remove a file or directory
#'
#' @param ... file name in case of connector_fs
#' @param connector_object connector_fs object
#' @export
#' @examples
#' connector <- connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$remove("iris.csv")
cnt_remove.connector_fs <- function(connector_object, ...) {
  path <- file.path(connector_object$path, ...)
  unlink(path)
}
