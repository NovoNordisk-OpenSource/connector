#' Remove a file or directory
#'
#' @param ... file name in case of Connector_fs
#' @param connector_object Connector_fs object
#'
#' @export
#'
#' @examples
#' connector <- Connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$remove("iris.csv")
remove.Connector_fs <- function(connector_object, ...) {
    unlink(connector_object$construct_path(...))
}

#' List content of the directory
#' @param ... Arguments to pass to the list.files function
#' @param connector_object Connector_fs object
#'
#' @export
#'
#' @examples
#' connector <- Connector_fs$new(tempdir())
#' connector$write(iris, "iris.csv")
#' connector$list_content()
list_content.Connector_fs <- function(connector_object, ...) {
    connector_object$get_path() %>%
        list.files(...)
}
