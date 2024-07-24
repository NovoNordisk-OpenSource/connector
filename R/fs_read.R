#' Read files based on the extension
#'
#' The aim of this function is to identify the extension on the file to dispatch it.
#'
#' @param path Path to the file
#' @param ... Other parameters for read's functions
#'
#' @return the result of the reading function
#'
#' @export
#'
#' @examples
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' write.csv(iris, temp_csv, row.names = FALSE)
#' read_file(temp_csv)
read_file <- function(path, ...) {
  find_ext <- tools::file_ext(path) |>
    assert_ext(method = "read_ext")

  class(path) <- c(find_ext, class(path))

  read_ext(path, ...)
}

#' Read a file based on this extension
#'
#' @inheritParams read_file
#' @name read_ext
#'
#' @return the result of the reading function
#' @export
#'
#' @examples
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' write.csv(iris, temp_csv, row.names = FALSE)
#' class(temp_csv) <- "csv"
#' read_ext(temp_csv)
read_ext <- function(path, ...) {
  UseMethod("read_ext")
}

# TODO: More documentation on methods and vroom:vroom for default ?
#' Default method for reading files
#' @rdname read_ext
#' @export
#' @importFrom vroom vroom
#'
#' @examples
#' temp_txt <- tempfile("iris", fileext = ".txt")
#' write.csv(iris, temp_txt, row.names = FALSE)
#' class(temp_txt) <- "txt"
#' read_ext(temp_txt)
read_ext.default <- function(path, ...) {
  cli::cli_alert_info("Using vroom to read the file:")
  table <- try(
    vroom::vroom(path, ...),
    silent = TRUE
  )

  if (inherits(table, "try-error")) {
    error_extension()
    return(invisible(NULL))
  }

  return(table)
}

#' For txt files
#' @rdname read_ext
#' @importFrom readr read_lines
#' @export
read_ext.txt <- function(path, ...) {
  readr::read_lines(path, ...)
}

#' For CSV files
#' @rdname read_ext
#' @importFrom readr read_csv
#' @export
read_ext.csv <- function(path, ...) {
  readr::read_csv(path, ...)
}


#' For parquet files
#' @rdname read_ext
#' @importFrom arrow read_parquet
#' @export
read_ext.parquet <- function(path, ...) {
  arrow::read_parquet(path, ...)
}


#' For RDS files
#' @rdname read_ext
#' @importFrom readr read_rds
#' @export
read_ext.rds <- function(path, ...) {
  readr::read_rds(path, ...)
}

#' For SAS files
#' @rdname read_ext
#' @export
read_ext.sas7bdat <- function(path, ...) {
  haven::read_sas(path, ...)
}


#' For XPT files
#' @rdname read_ext
#' @export
read_ext.xpt <- function(path, ...) {
  haven::read_xpt(path, ...)
}

#' For yaml files
#' @rdname read_ext
#' @export
read_ext.yml <- function(path, eval.expr = TRUE, ...) {
  yaml::read_yaml(file = path, eval.expr = eval.expr, ...)
}

#' @export
read_ext.yaml <- read_ext.yml
