#' Find File
#'
#' @param name Name of a file
#' @param root Path to the root folder
#'
#' @return A full name path to the file or a error if multiples files or 0.
#' @noRd
find_file <- function(name, root) {
  files <- list.files(
    path = root,
    pattern = paste0("^", name, "(\\.|$)"),
    full.names = TRUE
  )

  if (length(files) == 1) {
    return(files)
  } else {
    stop("No file found or multiple files found with the same name")
  }
}

#' List of supported files
#'
#' @return Used for this side effect
#' @noRd
#'
#' @examples
#' supported_fs()
supported_fs <- function() {
  fct <- getExportedValue("connector", "read_ext")
  # TODO: Make some great documentation on which formats are supported and which functions from other packages are used
  utils::methods(fct) |>
    suppressWarnings() |>
    as.character()
}

#' Test the extension of files
#'
#' @param ext the extension to test
#' @param method the S3 method to get methods
#'
#' @return An error if the extension method doesn't exists
#' @noRd
assert_ext <- function(ext, method) {
  valid <- sub(
    pattern = "^[^\\.]+\\.",
    replacement = "",
    x = as.character(utils::methods(method))
  )

  # TODO: Have to be better ! Use cli::bullets?
  checkmate::assert_choice(x = ext, choices = valid)
}

#' Error extension
#' Function to call when no method is found for the extension
#' @importFrom cli cli_abort
#' @importFrom rlang set_names
#' @noRd
error_extension <- function() {
  ext_supp <- supported_fs() |>
    rlang::set_names("*")
  c(
    "No method found for this extension, please implement your own method
    (to see an example run `connector::example_read_ext()`) or use a supported extension",
    "i" = "Supported extensions are:",
    ext_supp
  ) |>
    cli::cli_abort()
}

#' Example for creating a new method for reading files
#' @importFrom cli cli_inform cli_alert cli_code cli_text
#' @noRd
#' @examples
#' example_read_ext()
example_read_ext <- function() {
  cli::cli_inform("Here an example for CSV files:")
  cli::cli_alert("Your own method by creating a new function with the name `read_ext.<extension>`")
  cli::cli_code("read_ext.csv <- function(path, ...) {\n  readr::read_csv(path, ...)\n}")
  cli::cli_text("")
}
