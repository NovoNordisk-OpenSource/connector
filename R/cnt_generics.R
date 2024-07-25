#' Read content from the connector
#' @param connector_object `r rd_connector_params("connector_object")`
#' @param ... `r rd_connector_params("...")`
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
#' @param connector_object `r rd_connector_params("connector_object")`
#' @param x `r rd_connector_params("x")`
#' @param ... `r rd_connector_params("...")`
#' @return [invisible] `connector_object`
#' @export
cnt_write <- function(connector_object, x, ...) {
  UseMethod("cnt_write")
}

#' @export
cnt_write.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Remove content from the connector
#' @param connector_object `r rd_connector_params("connector_object")`
#' @param name `r rd_connector_params("name")`
#' @param ... `r rd_connector_params("...")`
#' @return [invisible] `connector_object`
#' @export
cnt_remove <- function(connector_object, name, ...) {
  UseMethod("cnt_remove")
}

#' @export
cnt_remove.default <- function(connector_object, ...) {
  method_error_msg()
}

#' List available content from the connector
#' @param connector_object `r rd_connector_params("connector_object")`
#' @param ... `r rd_connector_params("...")`
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
#' @param connector_object `r rd_connector_params("connector_object")`
#' @param name `r rd_connector_params("name")`
#' @param file `r rd_connector_params("file")`
#' @param ... `r rd_connector_params("...")`
#' @return [invisible] `file`
#' @export
cnt_download <- function(connector_object, name, file = basename(name), ...) {
  UseMethod("cnt_download")
}

#' @export
cnt_download.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Upload content to the connector
#' @param connector_object `r rd_connector_params("connector_object")`
#' @param file `r rd_connector_params("file")`
#' @param name `r rd_connector_params("name")`
#' @param ... `r rd_connector_params("...")`
#' @return [invisible] `connector_object`
#' @export
cnt_upload <- function(connector_object, file, name = basename(file), ...) {
  UseMethod("cnt_upload")
}

#' @export
cnt_upload.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Create a directory
#' @param name [character] The name of the directory to create
#' @param ... `r rd_connector_params("...")`
#' @export
cnt_create_directory <- function(connector_object, name, ...) {
  UseMethod("cnt_create_directory")
}

#' @export
cnt_create_directory.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Remove a directory
#' @param name [character] The name of the directory to remove
#' @param ... `r rd_connector_params("...")`
#' @export
cnt_remove_directory <- function(connector_object, name, ...) {
  UseMethod("cnt_remove_directory")
}

#' @export
cnt_remove_directory.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Disconnect from the database
#' @param connector_object `r rd_connector_params("connector_object")`
#' @param ... `r rd_connector_params("...")`
#' @return [invisible] `connector_object`
#' @export
cnt_disconnect <- function(connector_object, ...) {
  UseMethod("cnt_disconnect")
}

#' @export
cnt_disconnect.default <- function(connector_object, ...) {
  method_error_msg()
}

#' Use dplyr verbs to interact with the remote database table
#' @param connector_object `r rd_connector_params("connector_object")`
#' @param name `r rd_connector_params("name")`
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
