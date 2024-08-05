#' Write files based on the extension
#'
#' @description
#' `write_file()` is the backbone of all [cnt_write()] methods, where files are written
#' to a connector. The function is a wrapper around `write_ext()` where the appropriate
#' function to write the file is chosen depending on the file extension.
#'
#' @param x Object to write
#' @param file [character()] Path to write the file
#' @param ... Other parameters passed on the functions behind the methods for each file extension.
#' @return `write_file()`: [invisible()] file.
#' @export
write_file <- function(x, file, ...) {
  find_ext <- tools::file_ext(file) |>
    assert_ext("write_ext")

  class(file) <- c(find_ext, class(file))

  write_ext(file, x, ...)

  return(invisible(file))
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
#' @examples
#' # Write CSV file
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' write_file(iris, temp_csv)
#'
#' @rdname write_file
#' @export
write_ext.csv <- function(file, x, ...) {
  readr::write_csv(x = x, file = file, ...)
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
#' * `sas7bdat`: [haven::write_sas()]
#'
#' @rdname write_file
#' @export
write_ext.xpt <- function(file, x, ...) {
  # TODO: Use xportr to create nice pharmaverse style XPT files?
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
