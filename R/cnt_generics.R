#' Read content from the connector
#'
#' @description
#' Generic implementing of how to read content from the different connector objects:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name `r rd_connector_utils("name")`
#' @param ... `r rd_connector_utils("...")`
#' @return R object with the content. For rectangular data a [data.frame].
#' @export
read_cnt <- function(connector_object, name, ...) {
  UseMethod("read_cnt")
}

#' @export
read_cnt.default <- function(connector_object, name, ...) {
  method_error_msg(connector_object)
}

#' Write content to the connector
#'
#' @description
#' Generic implementing of how to write content to the different connector objects:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param x `r rd_connector_utils("x")`
#' @param name `r rd_connector_utils("name")`
#' @param overwrite Overwrite existing content if it exists in the connector.
#'   See [connector-options] for details. Default can be set globally with
#'   `options(connector.overwrite = TRUE/FALSE)` or environment variable
#'   `R_CONNECTOR_OVERWRITE`.
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
write_cnt <- function(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
) {
  UseMethod("write_cnt")
}

#' @export
write_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' Remove content from the connector
#'
#' @description
#' Generic implementing of how to remove content from different connectors:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name `r rd_connector_utils("name")`
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
remove_cnt <- function(connector_object, name, ...) {
  UseMethod("remove_cnt")
}

#' @export
remove_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' List available content from the connector
#'
#' @description
#' Generic implementing of how to list all content available for different connectors:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param ... `r rd_connector_utils("...")`
#' @return A [character] vector of content names
#' @export
list_content_cnt <- function(connector_object, ...) {
  UseMethod("list_content_cnt")
}

#' @export
list_content_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' Download content from the connector
#'
#' @description
#' Generic implementing of how to download files from a connector:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name `r rd_connector_utils("name")`
#' @param file `r rd_connector_utils("file")`
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
download_cnt <- function(connector_object, name, file = basename(name), ...) {
  UseMethod("download_cnt")
}

#' @export
download_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' Upload content to the connector
#'
#' @description
#' Generic implementing of how to upload files to a connector:
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param file `r rd_connector_utils("file")`
#' @param name `r rd_connector_utils("name")`
#' @param overwrite Overwrite existing content if it exists in the connector.
#'   See [connector-options] for details. Default can be set globally with
#'   `options(connector.overwrite = TRUE/FALSE)` or environment variable
#'   `R_CONNECTOR_OVERWRITE`.
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
upload_cnt <- function(
  connector_object,
  file,
  name = basename(file),
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
) {
  UseMethod("upload_cnt")
}

#' @export
upload_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' Create a directory
#'
#' @description
#' Generic implementing of how to create a directory for a connector.
#' Mostly relevant for file storage connectors.
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name [character] The name of the directory to create
#' @param ... `r rd_connector_utils("...")`
#' @param open `r rd_connector_utils("open")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
create_directory_cnt <- function(connector_object, name, open = TRUE, ...) {
  UseMethod("create_directory_cnt")
}

#' @export
create_directory_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' Remove a directory
#'
#' @description
#' Generic implementing of how to remove a directory for a connector.
#' Mostly relevant for file storage connectors.
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name [character] The name of the directory to remove
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
remove_directory_cnt <- function(connector_object, name, ...) {
  UseMethod("remove_directory_cnt")
}

#' @export
remove_directory_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' Upload a directory
#'
#' @description
#' Generic implementing of how to upload a directory for a connector.
#' Mostly relevant for file storage connectors.
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param dir [character] Path to the directory to upload
#' @param name [character] The name of the new directory to place the content in
#' @param overwrite Overwrite existing content if it exists in the connector.
#'   See [connector-options] for details. Default can be set globally with
#'   `options(connector.overwrite = TRUE/FALSE)` or environment variable
#'   `R_CONNECTOR_OVERWRITE`.
#' @param open `r rd_connector_utils("open")`
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
upload_directory_cnt <- function(
  connector_object,
  dir,
  name,
  overwrite = zephyr::get_option("overwrite", "connector"),
  open = FALSE,
  ...
) {
  UseMethod("upload_directory_cnt")
}

#' @export
upload_directory_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' Download a directory
#'
#' @description
#' Generic implementing of how to download a directory for a connector.
#' Mostly relevant for file storage connectors.
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name [character] The name of the directory to download
#' @param dir [character] Path to the directory to download to
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
download_directory_cnt <- function(connector_object, name, dir = name, ...) {
  UseMethod("download_directory_cnt")
}

#' @export
download_directory_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' Disconnect (close) the connection of the connector
#'
#' @description
#' Generic implementing of how to disconnect from the relevant connections.
#' Mostly relevant for DBI connectors.
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param ... `r rd_connector_utils("...")`
#' @return `r rd_connector_utils("inv_connector")`
#' @export
disconnect_cnt <- function(connector_object, ...) {
  UseMethod("disconnect_cnt")
}

#' @export
disconnect_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' Use dplyr verbs to interact with the remote database table
#'
#' @description
#' Generic implementing of how to create a [dplyr::tbl()] connection in order
#' to use dplyr verbs to interact with the remote database table.
#' Mostly relevant for DBI connectors.
#'
#' @param connector_object `r rd_connector_utils("connector_object")`
#' @param name `r rd_connector_utils("name")`
#' @param ... `r rd_connector_utils("...")`
#' @return A [dplyr::tbl] object.
#' @export
tbl_cnt <- function(connector_object, name, ...) {
  UseMethod("tbl_cnt")
}

#' @export
tbl_cnt.default <- function(connector_object, ...) {
  method_error_msg(connector_object)
}

#' @noRd
method_error_msg <- function(connector_object) {
  cli::cli_abort(
    c(
      "Method not implemented for class {.cls {class(connector_object)}}",
      "i" = "See the {.vignette [customize](connector::customize)} vignette
             on how to create custom connectors and methods"
    )
  )
}
