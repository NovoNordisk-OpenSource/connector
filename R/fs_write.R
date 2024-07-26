#' Write a file based on this extension
#'
#' @param x Object to write
#' @param file Path to write the file
#' @param ... Other parameters for write's functions
#'
#' @return the result of the Writing function
#' @export
#'
#' @examples
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' write_file(iris, temp_csv)
write_file <- function(x, file, ...) {
  find_ext <- tools::file_ext(file) |>
    assert_ext("write_ext")

  class(file) <- c(find_ext, class(file))

  write_ext(file, x, ...)
}

#' Write a file based on this extension
#'
#' @inheritParams write_file
#' @name write_ext
#'
#' @return the result of the Writing function
#' @export
#'
#' @examples
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' class(temp_csv) <- "csv"
#' write_ext(temp_csv, iris)
write_ext <- function(file, x, ...) {
  UseMethod("write_ext")
}

#' For txt files
#' @rdname write_ext
#' @importFrom readr write_lines
#' @export
write_ext.txt <- function(file, x, ...) {
  readr::write_lines(x, file, ...)
}

#' For CSV files
#' @rdname write_ext
#'
#' @importFrom readr write_csv
#' @export
write_ext.csv <- function(file, x, ...) {
  readr::write_csv(x, file, ...)
}

#' For parquet files
#' @rdname write_ext
#'
#' @importFrom arrow write_parquet
#' @export
write_ext.parquet <- function(file, x, ...) {
  arrow::write_parquet(x, file, ...)
}

#' For RDS files
#' @rdname write_ext
#'
#' @importFrom readr write_rds
#' @export
write_ext.rds <- function(file, x, ...) {
  readr::write_rds(x, file, ...)
}

#' For xpt files
#' @rdname write_ext
#'
#' @importFrom haven write_xpt
#' @export
write_ext.xpt <- function(file, x, ...) {
  # TODO: Use xportr to create nice pharmaverse style XPT files?
  haven::write_xpt(x, file, ...)
}
