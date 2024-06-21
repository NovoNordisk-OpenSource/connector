## Default methods for all connector object

#' Defaults method for connector object
#'
#' Those methods are a S3 method that dispatches to the specific methods for the connector object.
#'
#' @details
#' For example, if you have a connector object `Connector_fs`, you can use `read(Connector_fs, "file.csv")` to read the file. It will be dispatch to the `read.Connector_fs` method.
#' Why ? The main aim is to allow the user to use the same function for different connector objects by using the builder function `connector_fs` and add an "extra_class".
#' By doing so, you can create a subclass of the `Connector_fs` object and dispatch to the specific methods for this subclass.
#' For example, if you have a subclass `subclass`, you can use `read(subclass, "file.csv")` to read the file. It will be dispatch to the `read.subclass` method. And you can still use the `Connector_fs` methods.
#'
#' @param connector_object A connector object to be able to use functions from it
#' @param ... Additional arguments passed to the method
#'
#' @return The result of the read method
#' @export
#'
#' @name connector_methods
#'
read <- function(connector_object, ...) {
    UseMethod("read")
}

#' @export
read.default <- function(connector_object, ...) {
    stop("Method not implemented")
}

#' Write method for connector object
#' @rdname connector_methods
#' @export
write <- function(connector_object, ...) {
    UseMethod("write")
}

#' @export
write.default <- function(connector_object, ...) {
    stop("Method not implemented")
}

#' Remove method for connector object
#' @export
#' @rdname connector_methods
remove <- function(connector_object, ...) {
    UseMethod("remove")
}

#' @export
remove.default <- function(connector_object, ...) {
    stop("Method not implemented")
}

#' List content method for connector object
#' @export
#' @rdname connector_methods
list_content <- function(connector_object, ...) {
    UseMethod("list_content")
}

#' @export
list_content.default <- function(connector_object, ...) {
    stop("Method not implemented")
}

################
## DBI methods##
################

#' get_conn method for connector object
#' @rdname connector_methods
#' @export
get_conn <- function(connector_object, ...) {
    UseMethod("get_conn")
}

#' @export
get_conn.default <- function(connector_object, ...) {
    stop("Method not implemented")
}

#' disconnect method for connector object
#' @rdname connector_methods
#' @export
disconnect <- function(connector_object, ...) {
    UseMethod("disconnect")
}

#' @export
disconnect.default <- function(connector_object, ...) {
    stop("Method not implemented")
}

#' tbl method for connector object
#' @rdname connector_methods
#' @export
tbl <- function(connector_object, ...) {
    UseMethod("tbl")
}

#' @export
tbl.default <- function(connector_object, ...) {
    stop("Method not implemented")
}
