#' Read files for the Connector_fs class
#' @export
#' @param connector_object A Connector_fs object
#' @param name Name of the file to read
#' @param ... Other parameters to pass to the read_file function (depends on the extension of a file)
#'
#' @examples
#' connector <- Connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$read("iris.csv")
#' connector$remove("iris.csv")
cnt_read.Connector_fs <- function(connector_object, name, ...) {
  name |>
    find_file(root = connector_object$get_path()) |>
    read_file(...)
}

#' Write a file based on this extension
#' @export
#'
#' @param connector_object A Connector_fs object
#' @param x Object to write
#' @param file Path to write the file
#' @param ... Other parameters for write's functions
#'
#' @examples
#' connector <- Connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$remove("iris.csv")
#'
cnt_write.Connector_fs <- function(connector_object, x, file, ...) {
  x %>%
    write_file(connector_object$construct_path(file), ...)
}

#' List content of the directory
#' @param ... Arguments to pass to the list.files function
#' @param connector_object Connector_fs object
#' @export
#' @examples
#' connector <- Connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$list_content()
cnt_list_content.Connector_fs <- function(connector_object, ...) {
  connector_object$get_path() %>%
    list.files(...)
}

#' Remove a file or directory
#'
#' @param ... file name in case of Connector_fs
#' @param connector_object Connector_fs object
#' @export
#' @examples
#' connector <- Connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$remove("iris.csv")
cnt_remove.Connector_fs <- function(connector_object, ...) {
  unlink(connector_object$construct_path(...))
}
