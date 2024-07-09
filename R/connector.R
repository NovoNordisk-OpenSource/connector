#' R6 class for a general Connector object
#'
#' @param name [character] Table name
#'
#' @name Connector_object
#' @export

Connector <- R6::R6Class(
  classname = "Connector",
  public = list(

    #' @description List tables in the database
    #' @param ... Additional arguments passed to [DBI::dbListTables]
    #' @return A [character] vector of table names
    list_content = function(...) {
      self %>%
        cnt_list_content(...)
    },

    #' @description Read a table from the database
    #' @param ... Additional arguments passed to [DBI::dbReadTable]
    #' @return A [data.frame]
    read = function(name, ...) {
      self %>%
        cnt_read(name, ...)
    },

    #' @description Write a table to the database
    #' @param x [data.frame] Table to write
    #' @param ... Additional arguments passed to [DBI::dbWriteTable]
    write = function(x, name, ...) {
      self %>%
        cnt_write(x, name, ...)
    },

    #' @description Remove a table from the database
    #' @param ... Additional arguments passed to [DBI::dbRemoveTable]
    remove = function(name, ...) {
      self %>%
        cnt_remove(name, ...)
    }
  ),
  cloneable = FALSE
)

#' Defaults methods for all connector object
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
cnt_read <- function(connector_object, ...) {
  UseMethod("cnt_read")
}

#' @export
cnt_read.default <- function(connector_object, ...) {
  stop("Method not implemented")
}

#' Write method for connector object
#' @rdname connector_methods
#' @export
cnt_write <- function(connector_object, ...) {
  UseMethod("cnt_write")
}

#' @export
cnt_write.default <- function(connector_object, ...) {
  stop("Method not implemented")
}

#' Remove method for connector object
#' @export
#' @rdname connector_methods
cnt_remove <- function(connector_object, ...) {
  UseMethod("cnt_remove")
}

#' @export
cnt_remove.default <- function(connector_object, ...) {
  stop("Method not implemented")
}

#' List content method for connector object
#' @export
#' @rdname connector_methods
cnt_list_content <- function(connector_object, ...) {
  UseMethod("cnt_list_content")
}

#' @export
cnt_list_content.default <- function(connector_object, ...) {
  stop("Method not implemented")
}
