#' Find File
#'
#' Finds files in the following order:
#'
#' 1. The file is fully specified and exists (no message)
#' 2. Only one file is found with that name (with message)
#' 3. A file with the default extension exists (with message)
#'
#' @param name Name of a file
#' @param root Path to the root folder
#' @return A full name path to the file or a error if multiples files or 0.
#' @noRd
find_file <- function(name, root) {
  file <- file.path(root, name)

  if (file.exists(file)) {
    return(file)
  }

  files <- list.files(
    path = root,
    pattern = paste0("^", name, "(\\.[[:alnum:]]+|)$"),
    full.names = TRUE
  )

  if (!length(files)) {
    cli::cli_abort(
      "No file found with name: {.field {name}}"
    )
  }

  if (length(files) == 1) {
    zephyr::msg(
      "Found one file: {.file {files}}"
    )
    return(files)
  }

  ext <- zephyr::get_option("default_ext", "connector")
  file_ext <- files[tools::file_ext(files) == ext]

  if (length(file_ext) == 1) {
    zephyr::msg(
      "Found one file with default ({.field {ext}}) extension: {.file {file_ext}}"
    )
    return(file_ext)
  }

  cli::cli_abort(
    c(
      "Found several files with the same name: {.file {files}}",
      "i" = "Please specify file extension"
    )
  )
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
  utils::methods(fct) |>
    suppressWarnings() |>
    as.character()
}

#' Error extension
#' Function to call when no method is found for the extension
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
#' @noRd
#' @examples
#' example_read_ext()
example_read_ext <- function() {
  cli::cli_inform("Here an example for CSV files:")
  cli::cli_alert(
    "Your own method by creating a new function with the name `read_ext.<extension>`"
  )
  cli::cli_code(
    "read_ext.csv <- function(path, ...) {\n  readr::read_csv(path, ...)\n}"
  )
  cli::cli_text("")
}
