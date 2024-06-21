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
