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

  find_ext <- tools::file_ext(file) |>
    assert_ext("write_ext")

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

#' @description
#' `write_ext()` has methods defined for the following file extensions:
#'
#' @return `write_ext()`: The return of the functions behind the individual methods.
#' @rdname write_file
#' @export
write_ext <- function(file, x, ...) {
  UseMethod("write_ext")
}

#' @description
#' * `txt`: [readr::write_lines()]
#'
#' @rdname write_file
#' @export
write_ext.txt <- function(file, x, ...) {
  readr::write_lines(x = x, file = file, ...)
}

#' @description
#' * `csv`: [readr::write_csv()]
#'
#' @param delim [character()] Delimiter to use. Default is `","`.
#'
#' @examples
#' # Write CSV file
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' write_file(iris, temp_csv)
#'
#' @rdname write_file
#' @export
write_ext.csv <- function(file, x, delim = ",", ...) {
  readr::write_delim(x = x, file = file, delim = delim, ...)
}

#' @description
#' * `parquet`: [arrow::write_parquet()]
#'
#' @rdname write_file
#' @export
write_ext.parquet <- function(file, x, ...) {
  arrow::write_parquet(x = x, sink = file, ...)
}

#' @description
#' * `rds`: [readr::write_rds()]
#'
#' @rdname write_file
#' @export
write_ext.rds <- function(file, x, ...) {
  readr::write_rds(x = x, file = file, ...)
}

#' @description
#' * `xpt`: [haven::write_xpt()]
#'
#' @rdname write_file
#' @export
write_ext.xpt <- function(file, x, ...) {
  haven::write_xpt(data = x, path = file, ...)
}

#' @description
#' * `yml`/`yaml`: [yaml::write_yaml()]
#'
#' @rdname write_file
#' @export
write_ext.yml <- function(file, x, ...) {
  yaml::write_yaml(x = x, file = file, ...)
}

#' @export
write_ext.yaml <- write_ext.yml

#' @description
#' * `json`: [jsonlite::write_json()]
#'
#' @rdname write_file
#' @export
write_ext.json <- function(file, x, ...) {
  jsonlite::write_json(x = x, path = file, ...)
}

#' @description
#' * `excel`: [writexl::write_xlsx()]
#'
#' @rdname write_file
#' @export
write_ext.xlsx <- function(file, x, ...) {
  writexl::write_xlsx(x = x, path = file, ...)
}
