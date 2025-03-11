#' Read files based on the extension
#'
#' @description
#' `read_file()` is the backbone of all [read_cnt] methods, where files are read
#' from their source. The function is a wrapper around [read_ext()], that controls
#' the dispatch based on the file extension.
#'
#' @param path [character()] Path to the file.
#' @param ... Other parameters passed on the functions behind the methods for each file extension.
#' @return the result of the reading function
#' @export
read_file <- function(path, ...) {
  find_ext <- tools::file_ext(path)

  class(path) <- c(find_ext, class(path))

  read_ext(path, ...)
}

#' @description
#' `read_ext()` controls which packages and functions are used to read the individual file extensions.
#' Below is a list of all the pre-defined methods:
#'
#' @rdname read_file
#' @export
read_ext <- function(path, ...) {
  UseMethod("read_ext")
}

#' @description
#' * `default`: All extensions not listed below is attempted to be read with [vroom::vroom()]
#'
#' @rdname read_file
#' @export
read_ext.default <- function(path, ...) {
  zephyr::msg_info("Using vroom to read the file:")
  table <- try(
    vroom::vroom(file = path, ...),
    silent = TRUE
  )

  if (inherits(table, "try-error")) {
    error_extension()
    return(invisible(NULL))
  }

  return(table)
}

#' @description
#' * `txt`: [readr::read_lines()]
#'
#' @rdname read_file
#' @export
read_ext.txt <- function(path, ...) {
  readr::read_lines(file = path, ...)
}

#' @description
#' * `csv`: [readr::read_csv()]
#'
#' @param delim [character()] Delimiter to use. Default is `","`.
#'
#' @examples
#' # Read CSV file
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' write.csv(iris, temp_csv, row.names = FALSE)
#' read_file(temp_csv)
#'
#' @rdname read_file
#' @param delim Single character used to separate fields within a record.
#' @export
read_ext.csv <- function(path, delim = ",", ...) {
  readr::read_delim(file = path, delim = delim, ...)
}

#' @description
#' * `parquet`: [arrow::read_parquet()]
#'
#' @rdname read_file
#' @export
read_ext.parquet <- function(path, ...) {
  arrow::read_parquet(file = path, ...)
}

#' @description
#' * `rds`: [readr::read_rds()]
#'
#' @rdname read_file
#' @export
read_ext.rds <- function(path, ...) {
  readr::read_rds(file = path, ...)
}

#' @description
#' * `sas7bdat`: [haven::read_sas()]
#'
#' @rdname read_file
#' @export
read_ext.sas7bdat <- function(path, ...) {
  haven::read_sas(data_file = path, ...)
}

#' @description
#' * `xpt`: [haven::read_xpt()]
#'
#' @rdname read_file
#' @export
read_ext.xpt <- function(path, ...) {
  haven::read_xpt(file = path, ...)
}

#' @description
#' * `yml`/`yaml`: [yaml::read_yaml()]
#'
#' @rdname read_file
#' @export
read_ext.yml <- function(path, ...) {
  yaml::read_yaml(file = path, ...)
}

#' @export
read_ext.yaml <- read_ext.yml

#' @description
#' * `json`: [jsonlite::read_json()]
#'
#' @rdname read_file
#' @export
read_ext.json <- function(path, ...) {
  jsonlite::read_json(path = path, ...)
}

#' @description
#' * `excel`: [readxl::read_excel()]
#'
#' @rdname read_file
#' @export
read_ext.xlsx <- function(path, ...) {
  readxl::read_excel(path = path, ...)
}

#' @export
read_ext.xls <- read_ext.xlsx
