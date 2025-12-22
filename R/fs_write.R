#' Write files based on the extension
#'
#' @description
#' `write_file()` is the backbone of all [write_cnt()] methods, where files are written
#' to a connector. The function is a wrapper around `write_ext()` where the appropriate
#' function to write the file is chosen depending on the file extension.
#'
#' @details
#' Note that `write_file()` will not overwrite existing files unless `overwrite = TRUE`,
#' while all methods for `write_ext()` will overwrite existing files by default.
#'
#' @param x Object to write
#' @param file [character()] Path to write the file.
#' @param overwrite [logical] Overwrite existing content if it exists.
#' @param ... Other parameters passed on the functions behind the methods for each file extension.
#' @return `write_file()`: [invisible()] file.
#' @export
write_file <- function(x, file, overwrite = FALSE, ...) {
  check_file_exists(file, overwrite, ...)

  find_ext <- tools::file_ext(file)

  class(file) <- c(find_ext, class(file))

  write_ext(file, x, ...)

  return(invisible(file))
}

#' Checks if a file already exists.
#' Some readr functions allows append, which is why it is included in the check as well
#' @noRd
check_file_exists <- function(file, overwrite, ..., .envir = parent.frame()) {
  if (
    fs::file_exists(file) &&
      !overwrite &&
      !isTRUE(rlang::list2(...)[["append"]])
  ) {
    cli::cli_abort(
      "File {.file {file}} already exists. Use {.code overwrite = TRUE} to overwrite.",
      .envir = .envir
    )
  }
}


#' Write Objects to Files Using S7 Method Dispatch
#'
#' @description
#' `write_ext` is an S7 generic function that supports double dispatch for writing objects.
#' It allows you to define methods based on both the type of the object being written.
#'
#' @details
#' This generic is designed to support the connector package's workflow for writing files, but
#' also to allow for extensibility through S7 method dispatch based on file extensions.
#' This makes it possible for users to create custom methods for saving different types of objects.
#'
#' When writing files through a connector, the file extension
#' is automatically detected and added as a class to the file path. This enables
#' double dispatch based on both the object type (`x`) and the file extension (`file`),
#' allowing you to define specialized save methods for different combinations.
#'
#' ## Method Dispatch
#' The generic dispatches on two arguments:
#' \itemize{
#'   \item `x`: The object to be written (e.g., data.frame, list, S7 object)
#'   \item `file`: The file path with the file extension as its class
#' }
#'
#' This allows you to create methods like:
#' \itemize{
#'   \item `write_ext(data.frame, "csv")` - for saving data frames to CSV
#'   \item `write_ext(list, "json")` - for saving lists to JSON
#'   \item `write_ext(S7_object, "rds")` - for saving S7 objects to RDS
#' }
#'
#' @param x The object to write to the file. Can be any R object.
#' @param file A character string specifying the file path. The file extension
#'   will be used for method dispatch.
#' @param ... Additional arguments passed to the underlying write function.
#'   These arguments are specific to the data format being written and may include
#'   parameters such as file encoding, compression options, or format-specific settings.
#'
#' @return The file path (invisibly), or whatever the specific method returns.

#' @export
write_ext <- S7::new_generic("write_ext", c("x","file"))

