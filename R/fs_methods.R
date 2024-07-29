#' @description
#' * [connector_fs]: Uses [read_file()] to read a given file.
#' The underlying function used, and thereby also the arguments available
#' through `...` depends on the file extension.
#'
#' @examples
#' # Write and read a CSV file using the file storage connector
#' cnt <- connector_fs$new(tempdir())
#'
#' cnt |>
#'   cnt_write(iris, "iris.csv")
#'
#' cnt |>
#'   cnt_read("iris.csv") |>
#'   head()
#'
#' @rdname cnt_read
#' @export
cnt_read.connector_fs <- function(connector_object, name, ...) {
  name |>
    find_file(root = connector_object$path) |>
    read_file(...)
}

#' @description
#' * [connector_fs]: Uses [write_file()] to Write a file based on the file extension.
#' The underlying function used, and thereby also the arguments available
#' through `...` depends on the file extension.
#'
#' @examples
#' # Write different file types to a file storage
#' cnt <- connector_fs$new(tempdir())
#'
#' cnt |>
#'   cnt_list_content(pattern = "iris")
#'
#' # rds file
#' cnt |>
#'   cnt_write(iris, "iris.rds")
#'
#' # CSV file
#' cnt |>
#'   cnt_write(iris, "iris.csv")
#'
#' cnt |>
#'   cnt_list_content(pattern = "iris")
#'
#' @rdname cnt_write
#' @export
cnt_write.connector_fs <- function(connector_object, x, name, ...) {
  file <- file.path(connector_object$path, name)
  write_file(x, file, ...)
  return(invisible(connector_object))
}

#' @description
#' * [connector_fs]: Uses [list.files()] to list all files at the path of the connector.
#'
#' @examples
#' # List content in a file storage
#' cnt <- connector_fs$new(tempdir())
#'
#' cnt |>
#'   cnt_list_content()
#'
#' # Only list CSV files using the pattern argument of list.files
#'
#' cnt |>
#'   cnt_list_content(pattern = "\\.csv$")
#'
#' @rdname cnt_list_content
#' @export
cnt_list_content.connector_fs <- function(connector_object, ...) {
  connector_object$path %>%
    list.files(...)
}

#' @description
#' * [connector_fs]: Uses [unlink()] to delete the file.
#'
#' @examples
#' # Remove a file from the file storage
#' cnt <- connector_fs$new(tempdir())
#'
#' cnt |>
#'   cnt_write("this is an example", "example.txt")

#' cnt |>
#'   cnt_list_content(pattern = "example.txt")
#'
#' cnt |>
#'   cnt_read("example.txt")
#'
#' cnt |>
#'   cnt_remove("example.txt")
#'
#' cnt |>
#'   cnt_list_content(pattern = "example.txt")
#'
#' @rdname cnt_remove
#' @export
cnt_remove.connector_fs <- function(connector_object, name, ...) {
  path <- file.path(connector_object$path, name)
  unlink(path, ...)
  return(invisible(connector_object))
}

#' @description
#' * [connector_fs]: Uses [file.copy()] to copy a file from the file storage to the desired `file`.
#'
#' @examples
#' # Download file from a file storage
#' cnt <- connector_fs$new(tempdir())
#'
#' cnt |>
#'   cnt_write("this is an example", "example.txt")
#'
#' list.files(pattern = "example.txt")
#'
#' cnt |>
#'   cnt_download("example.txt")
#'
#' list.files(pattern = "example.txt")
#' readLines("example.txt")
#'
#' @rdname cnt_download
#' @export
cnt_download.connector_fs <- function(connector_object, name, file = basename(name), ...) {
  name <- file.path(connector_object$path, name)
  file.copy(from = name, to = file, ...)
  return(invisible(file))
}

#' @description
#' * [connector_fs]: Uses [file.copy()] to copy the `file` to the file storage.
#'
#' @examples
#' # Upload file to a file storage
#'
#' writeLines("this is an example", "example.txt")
#'
#' cnt <- connector_fs$new(tempdir())
#'
#' cnt |>
#'   cnt_list_content(pattern = "example.txt")
#'
#' cnt |>
#'   cnt_upload("example.txt")
#'
#' cnt |>
#'   cnt_list_content(pattern = "example.txt")
#'
#' @rdname cnt_upload
#' @export
cnt_upload.connector_fs <- function(connector_object, file, name = basename(file), ...) {
  name <- file.path(connector_object$path, name)
  file.copy(from = file, to = name, ...)
  return(invisible(connector_object))
}

#' @description
#' * [connector_fs]: Uses [dir.create()] to create a directory at the path of the connector.
#'
#' @examples
#' # Create a directory in a file storage
#'
#' cnt <- connector_fs$new(tempdir())
#'
#' cnt |>
#'   cnt_list_content(pattern = "new_folder")
#'
#' cnt |>
#'   cnt_create_directory("new_folder") |>
#'   cnt_list_content(pattern = "new_folder")
#'
#' cnt |>
#'   cnt_remove_directory("new_folder")
#'
#' @rdname cnt_create_directory
#' @export
cnt_create_directory.connector_fs <- function(connector_object, name, ...) {
  path <- file.path(connector_object$path, name)
  dir.create(path = path, ...)
  return(invisible(connector_object))
}

#' @description
#' * [connector_fs]: Uses [unlink()] with `recursive = TRUE` to remove a directory at the path of the connector.
#'
#' @examples
#' # Remove a directory from a file storage
#'
#' cnt <- connector_fs$new(tempdir())
#'
#' cnt |>
#'   cnt_create_directory("new_folder") |>
#'   cnt_list_content(pattern = "new_folder")
#'
#' cnt |>
#'   cnt_remove_directory("new_folder") |>
#'   cnt_list_content(pattern = "new_folder")
#'
#' @rdname cnt_remove_directory
#' @export
cnt_remove_directory.connector_fs <- function(connector_object, name, ...) {
  path <- file.path(connector_object$path, name)
  unlink(x = path, recursive = TRUE, ...)
  return(invisible(connector_object))
}
