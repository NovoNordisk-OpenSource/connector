#' General connector object
#' @description
#' This R6 class is a general class for all connectors.
#' It is used to define the methods that all connectors should have.
#' New connectors should inherit from this class,
#' and the methods described in [connector_methods] should be implemented.
#' @param name [character] Name of the content to read, write, or remove. Typically the table name,
#' @param ... Additional arguments passed to the method for the individual connector.
#' @seealso `vignette("customize")` on how to create custom connectors and methods,
#' and how concrete examples in [connector_methods], [connector_fs] and [connector_dbi].
#' @export

connector <- R6::R6Class(
  classname = "connector",
  public = list(

    #' @description List content
    #' @return A [character] vector of content names
    list_content = function(...) {
      self %>%
        cnt_list_content(...)
    },

    #' @description Read content
    #' @return The result of the read method
    read = function(name, ...) {
      self %>%
        cnt_read(name, ...)
    },

    #' @description Write content
    #' @param x The object to write to the connection
    write = function(x, name, ...) {
      self %>%
        cnt_write(x, name, ...)
    },

    #' @description Remove or delete content
    remove = function(name, ...) {
      self %>%
        cnt_remove(name, ...)
    }
  )
)

#' Defaults methods for all connector object
#'
#' @description
#' These methods are a S3 method that dispatches to the specific methods for the connector object.
#'
#' @details
#' For example, if you have a connector object `connector_fs`, you can use `cnt_read(connector_fs, "file.csv")`
#' to read the file. It will be dispatch to the `cnt_read.connector_fs` method.
#' Why? The main aim is to allow the user to use the same function for different connector objects by
#' using the builder function `connector_fs` and add an "extra_class".
#' By doing so, you can create a subclass of the `connector_fs` object and
#' dispatch to the specific methods for this subclass.
#' For example, if you have a subclass `subclass`, you can use `cnr_read(subclass, "file.csv")` to read the file.
#' It will be dispatch to the `cnt_read.subclass` method. And you can still use the `connector_fs` methods.
#'
#' @param connector_object A connector object to be able to use functions from it
#' @param ... Additional arguments passed to the method
#' @name connector_methods
NULL

#' Read method for connector object
#' @rdname connector_methods
#' @return The result of the read method
#' @export
cnt_read <- function(connector_object, ...) {
  UseMethod("cnt_read")
}

#' @export
cnt_read.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Write method for connector object
#' @rdname connector_methods
#' @return The result of the write method
#' @export
cnt_write <- function(connector_object, ...) {
  UseMethod("cnt_write")
}

#' @export
cnt_write.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Remove method for connector object
#' @return The result of the remove method
#' @export
#' @rdname connector_methods
cnt_remove <- function(connector_object, ...) {
  UseMethod("cnt_remove")
}

#' @export
cnt_remove.default <- function(connector_object, ...) {
  method_error_msg()
}

#' List content method for connector object
#' @return The result of the list_content method
#' @export
#' @rdname connector_methods
cnt_list_content <- function(connector_object, ...) {
  UseMethod("cnt_list_content")
}

#' @export
cnt_list_content.default <- function(connector_object, ...) {
  method_error_msg()
}

method_error_msg <- function(env = parent.frame()) {
  cli::cli_abort(c(
    "Method not implemented for class {.cls {class(connector_object)}}",
    "i" = "See the {.vignette [customize](connector::customize)} vignette on how to create custom connectors and methods"
    ),
    .envir = env)
}


