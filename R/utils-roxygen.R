#' Documentation for central parameters reused in several connectors and functions
#' this solution was chosen since roxygen does not support the use of @inheritParams for R6 objects
#' @noRd
rd_connector_params <- function(param) {
  x <- c(
    "name" = "[character] Name of the content to read, write, or remove. Typically the table name.",
    "x" = "The object to write to the connection",
    "file" =  "[character] Path to the file to download to or upload from",
    "..." = "Additional arguments passed to the method for the individual connector.",
    "extra_class" = "[character] Extra class to assign to the new connector.",
    "connector_object" = "[connector] The connector object to use."
    )
  x[[param]]
}
