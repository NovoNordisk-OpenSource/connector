#' @title Class connector_fs
#' @description The connector_fs class is a file system connector for accessing and manipulating files in a local file system.
#' @importFrom R6 R6Class
#' @export
connector_fs <- R6::R6Class(
  "connector_fs",
  public = list(
    #' @description Initializes the connector_fs class
    #' @param path Path to the file system
    #' @param access Access type ("rw" by default)
    initialize = function(path, access = "rw") {
      private$path <- assert_path(path, access)
    },
    #' @description Returns the list of files in the specified path
    #' @param ... Other parameters to pass to the list.files function
    list_content = function(...) {
      list.files(path = private$path, ...)
    },
    #' @description Constructs a complete path by combining the specified access path with the provided elements
    #' @param ... Elements to construct the path
    construct_path = function(...) {
      file.path(private$path, ...)
    },
    #' @description Reads the content of the specified file using the private access path and additional options
    #' @param name Name of the file to read
    #' @param ... Other parameters to pass to the read_file function (depends on the extension of a file)
    read = function(name, ...) {
      name |>
        find_file(root = private$path) |>
        read_file(...)
    },
    #' @description Writes the specified content to the specified file using the private access path and additional options
    #' @param x Content to write to the file
    #' @param file File name
    #' @param ... Other parameters to pass to the write_file function (depends on the extension of a file)
    write = function(x, file, ...) {
      write_file(x, self$construct_path(file), ...)
    }
  ),
  private = list(
    path = character(0)
  ),
  cloneable = FALSE
)

#' Validate the path and access
#'
#' @description The assert_path function validates the path and access type for file system operations.
#'
#' @param path Path to be validated
#' @param access Type of access ("rw" for read/write by default)
#'
#' @return Invisible path
#'
#' @export
#'
#' @importFrom checkmate makeAssertCollection assert_character assert_directory_exists reportAssertions
assert_path <- function(path, access) {
  val <- checkmate::makeAssertCollection()

  checkmate::assert_character(
    x = path,
    len = 1,
    any.missing = FALSE,
    add = val
  )

  checkmate::assert_directory_exists(
    x = path,
    access = access,
    add = val
  )

  checkmate::reportAssertions(
    val
  )

  return(
    invisible(path)
  )
}
#' Find File
#'
#' @param name Name of a file
#' @param root Path to the root folder
#'
#' @return A full name path to the file or a error if multiples files or 0.
#'
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
#' @export
#'
#' @examples
#' supported_fs()
supported_fs <- function() {
  # TODO: Make some great documentation on which formats are supported and which functions from other packages are used
}

#' Test the extension of files
#'
#' @param ext the extension to test
#' @param method the S3 method to get methods
#'
#' @return An error if the extension method doesn't exists
#'
assert_ext <- function(ext, method) {
  valid <- sub(
    pattern = "^[^\\.]+\\.",
    replacement = "",
    x = as.character(utils::methods(method))
  )

  # TODO: Provide information on supported methods when using undefined extension (with cli) + skeleton for adding new

  checkmate::assert_choice(x = ext, choices = valid)
}

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
