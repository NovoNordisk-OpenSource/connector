#' Read content from the connector
#'
#' @description
#' Generic implementing how to read content from the different connector objects:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param ... `r rd_connector_utils("...")`
#' @return R object with the content. For rectangular data a [data.frame].
#' @export
cnt_read <- function(connector_object, ...) {
  UseMethod("cnt_read")
}

#' @export
cnt_read.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Write content to the connector
#'
#' @description
#' Generic implementing how to write content to the different connector objects:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param x `r rd_connector_utils("x")`
#' @param name `r rd_connector_utils("name")`
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
cnt_write <- function(connector_object, x, name, ...) {
  UseMethod("cnt_write")
}

#' @export
cnt_write.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Remove content from the connector
#'
#' @description
#' Generic implementing how to remove content from different connectors:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name `r rd_connector_utils("name")`
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
cnt_remove <- function(connector_object, name, ...) {
  UseMethod("cnt_remove")
}

#' @export
cnt_remove.default <- function(connector_object, ...) {
  method_error_msg()
}

#' List available content from the connector
#'
#' @description
#' Generic implementing how to list all content available for different connectors:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param ... `r rd_connector_utils("...")`
#' @return A [character] vector of content names
#' @export
cnt_list_content <- function(connector_object, ...) {
  UseMethod("cnt_list_content")
}

#' @export
cnt_list_content.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Download content from the connector
#'
#' @description
#' Generic implementing how to download files from a connector:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name `r rd_connector_utils("name")`
#' @param file `r rd_connector_utils("file")`
#' @param ... `r rd_connector_utils("...")`
#' @return [invisible] file.
#' @export
cnt_download <- function(connector_object, name, file = basename(name), ...) {
  UseMethod("cnt_download")
}

#' @export
cnt_download.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Upload content to the connector
#'
#' @description
#' Generic implementing how to upload files to a connector:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param file `r rd_connector_utils("file")`
#' @param name `r rd_connector_utils("name")`
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
cnt_upload <- function(connector_object, file, name = basename(file), ...) {
  UseMethod("cnt_upload")
}

#' @export
cnt_upload.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Create a directory
#'
#' @description
#' Generic implementing how to create a directory for a connector.
#' Mostly relevant for file storage connectors.
#'
#' @param name [character] The name of the directory to create
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
cnt_create_directory <- function(connector_object, name, ...) {
  UseMethod("cnt_create_directory")
}

#' @export
cnt_create_directory.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Remove a directory
#'
#' @description
#' Generic implementing how to remove a directory for a connector.
#' Mostly relevant for file storage connectors.
#'
#' @param name [character] The name of the directory to remove
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
cnt_remove_directory <- function(connector_object, name, ...) {
  UseMethod("cnt_remove_directory")
}

#' @export
cnt_remove_directory.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Disconnect from the database
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
cnt_disconnect <- function(connector_object, ...) {
  UseMethod("cnt_disconnect")
}

#' @export
cnt_disconnect.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Use dplyr verbs to interact with the remote database table
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name `r rd_connector_utils("name")`
#' @return A [dplyr::tbl] object.
#' @export
cnt_tbl <- function(connector_object, name, ...) {
  UseMethod("cnt_tbl")
}

#' @export
cnt_tbl.default <- function(connector_object, ...) {
  method_error_msg()
}

#' @noRd
method_error_msg <- function(env = parent.frame()) {
  cli::cli_abort(
    c(
      "Method not implemented for class {.cls {class(connector_object)}}",
      "i" = "See the {.vignette [customize](connector::customize)} vignette
             on how to create custom connectors and methods"
    ),
    .envir = env
  )
}
