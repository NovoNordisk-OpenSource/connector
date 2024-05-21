# File system methods

connector_fs <- R6::R6Class("connector_fs",
  public = list(
    initialize = function(path, access = "rw") {
      private$path <- assert_path(path, access)
    },
    list_content = function(...) {
      list.files(path = private$path, ...)
    },
    construct_path = function(...) {
      file.path(private$path, ...)
    },
    read = function(name, ...) {
      name |>
        find_file(root = private$path) |>
        read_file(...)
    },
    write = function(x, file, ...) {
      write_file(x, self$construct_path(file), ...)
    }
  ),
  private = list(
    path = character(0)
  ),
  cloneable = FALSE
)

assert_path <- function(path, access) {
  val <- checkmate::makeAssertCollection()
  checkmate::assert_character(x = path, len = 1, any.missing = FALSE, add = val)
  checkmate::assert_directory_exists(x = path, access = access, add = val)
  checkmate::reportAssertions(val)
  return(invisible(path))
}

find_file <- function(name, root) {
  files <- list.files(path = root, pattern = paste0("^", name, "(\\.|$)"), full.names = TRUE)
  if (length(files) == 1) {
    return(files)
  } else {
    stop("No file found or multiple files found with the same name")
  }
}

supported_fs <- function() {
  # TODO: Make some great documentation on which formats are supported and which functions from other packages are used
}

assert_ext <- function(ext, method) {

  valid <- sub(
    pattern = "^[^\\.]+\\.",
    replacement = "",
    x = as.character(utils::methods(method))
    )

  # TODO: Provide information on supported methods when using undefined extension (with cli) + skeleton for adding new

  checkmate::assert_choice(x = ext, choices = valid)
}

read_file <- function(path, ...) {
  UseMethod("read_file")
}

#' @export

read_file.default <- function(path, ...) {

  find_ext <- tools::file_ext(path) |>
    assert_ext(method = "read_ext")

  class(path) <- c(find_ext, class(path))

  read_ext(path, ...)
}

read_ext <- function(path, ...) {
  UseMethod("read_ext")
}

#' @export

read_ext.csv <- function(path, ...) {
  readr::read_csv(path, ...)
}

#' @export

read_ext.parquet <- function(path, ...) {
  arrow::read_parquet(path, ...)
}

#' @export

read_ext.rds <- function(path, ...) {
  readr::read_rds(path, ...)
}

#' @export

read_ext.sas7bdat <- function(path, ...) {
  haven::read_sas(path, ...)
}

#' @export

read_ext.xpt <- function(path, ...) {
  haven::read_xpt(path, ...)
}

write_file <- function(x, file, ...) {
  UseMethod("write_file")
}

#' @export

write_file.default <- function(x, file, ...) {

  find_ext <- tools::file_ext(file) |>
    assert_ext("write_ext")

  class(file) <- c(find_ext, class(file))

  write_ext(file, x, ...)
}

write_ext <- function(file, x, ...) {
  UseMethod("write_ext")
}

#' @export

write_ext.csv <- function(file, x, ...) {
  readr::write_csv(x, file, ...)
}

#' @export

write_ext.parquet <- function(file, x, ...) {
  arrow::write_parquet(x, file, ...)
}

#' @export

write_ext.rds <- function(file, x, ...) {
  readr::write_rds(x, file, ...)
}

#' @export

write_ext.xpt <- function(file, x, ...) {
  # TODO: Use xportr to create nice pharmaverse style XPT files?
  haven::write_xpt(x, file, ...)
}
