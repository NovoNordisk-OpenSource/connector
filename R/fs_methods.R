#' @description
#' * [ConnectorFS]: Uses [read_file()] to read a given file.
#' The underlying function used, and thereby also the arguments available
#' through `...` depends on the file extension.
#'
#' @examples
#' # Write and read a CSV file using the file storage connector
#' cnt <- connector_fs(tempdir())
#'
#' cnt |>
#'   write_cnt(iris, "iris.csv")
#'
#' cnt |>
#'   read_cnt("iris.csv") |>
#'   head()
#'
#' @rdname read_cnt
#' @export
read_cnt.ConnectorFS <- function(connector_object, name, ...) {
  name |>
    find_file(root = connector_object$path) |>
    read_file(...)
}

#' @description
#' * [ConnectorFS]: Uses [write_file()] to Write a file based on the file extension.
#' The underlying function used, and thereby also the arguments available
#' through `...` depends on the file extension.
#'
#' @examples
#' # Write different file types to a file storage
#' cnt <- connector_fs(tempdir())
#'
#' cnt |>
#'   list_content_cnt(pattern = "iris")
#'
#' # rds file
#' cnt |>
#'   write_cnt(iris, "iris.rds")
#'
#' # CSV file
#' cnt |>
#'   write_cnt(iris, "iris.csv")
#'
#' cnt |>
#'   list_content_cnt(pattern = "iris")
#'
#' @rdname write_cnt
#' @export
write_cnt.ConnectorFS <- function(connector_object, x, name, ...) {
  file <- file.path(connector_object$path, name)
  write_file(
    x,
    file,
    ...
  )
  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [list.files()] to list all files at the path of the connector.
#'
#' @examples
#' # List content in a file storage
#' cnt <- connector_fs(tempdir())
#'
#' cnt |>
#'   list_content_cnt()
#'
#' # Only list CSV files using the pattern argument of list.files
#'
#' cnt |>
#'   list_content_cnt(pattern = "\\.csv$")
#'
#' @rdname list_content_cnt
#' @export
list_content_cnt.ConnectorFS <- function(connector_object, ...) {
  connector_object$path |>
    list.files(...)
}

#' @description
#' * [ConnectorFS]: Uses [unlink()] to delete the file.
#'
#' @examples
#' # Remove a file from the file storage
#' cnt <- connector_fs(tempdir())
#'
#' cnt |>
#'   write_cnt("this is an example", "example.txt")

#' cnt |>
#'   list_content_cnt(pattern = "example.txt")
#'
#' cnt |>
#'   read_cnt("example.txt")
#'
#' cnt |>
#'   remove_cnt("example.txt")
#'
#' cnt |>
#'   list_content_cnt(pattern = "example.txt")
#'
#' @rdname remove_cnt
#' @export
remove_cnt.ConnectorFS <- function(connector_object, name, ...) {
  path <- file.path(
    connector_object$path,
    name
  )

  unlink(path, ...)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [file.copy()] to copy a file from the file storage to the desired `file`.
#'
#' @examples
#' # Download file from a file storage
#' cnt <- connector_fs(tempdir())
#'
#' cnt |>
#'   write_cnt("this is an example", "example.txt")
#'
#' list.files(pattern = "example.txt")
#'
#' cnt |>
#'   download_cnt("example.txt")
#'
#' list.files(pattern = "example.txt")
#' readLines("example.txt")
#'
#' cnt |>
#'   remove_cnt("example.txt")
#'
#' @rdname download_cnt
#' @export
download_cnt.ConnectorFS <- function(
    connector_object,
    name,
    file = basename(name),
    ...) {
  name <- file.path(connector_object$path, name)
  file.copy(from = name, to = file, ...)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [file.copy()] to copy the `file` to the file storage.
#'
#' @examples
#' # Upload file to a file storage
#'
#' writeLines("this is an example", "example.txt")
#'
#' cnt <- connector_fs(tempdir())
#'
#' cnt |>
#'   list_content_cnt(pattern = "example.txt")
#'
#' cnt |>
#'   upload_cnt("example.txt")
#'
#' cnt |>
#'   list_content_cnt(pattern = "example.txt")
#'
#' cnt |>
#'   remove_cnt("example.txt")
#'
#' file.remove("example.txt")
#'
#' @rdname upload_cnt
#' @export
upload_cnt.ConnectorFS <- function(
    connector_object,
    file,
    name = basename(file),
    ...) {
  name <- file.path(connector_object$path, name)

  file.copy(from = file, to = name, ...)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [dir.create()] to create a directory at the path of the connector.
#'
#' @param open create a new connector object
#'
#' @examples
#' # Create a directory in a file storage
#'
#' cnt <- connector_fs(tempdir())
#'
#' cnt |>
#'   list_content_cnt(pattern = "new_folder")
#'
#' cnt |>
#'   create_directory_cnt("new_folder")
#'
#' # This will return new connector object of a newly created folder
#' new_connector <- cnt |>
#'   list_content_cnt(pattern = "new_folder")
#'
#' cnt |>
#'   remove_directory_cnt("new_folder")
#'
#' @rdname create_directory_cnt
#' @export
create_directory_cnt.ConnectorFS <- function(
    connector_object,
    name,
    ...,
    open = TRUE) {
  path <- file.path(connector_object$path, name)
  dir.create(path = path, ...)

  # create a new connector object from the new path
  if (open) {
    connector_object <- ConnectorFS$new(path)
  }

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [unlink()] with `recursive = TRUE` to remove a directory at the path of the connector.
#'
#' @examples
#' # Remove a directory from a file storage
#'
#' cnt <- connector_fs(tempdir())
#'
#' cnt |>
#'   create_directory_cnt("new_folder")
#'
#' cnt |>
#'   list_content_cnt(pattern = "new_folder")
#'
#' cnt |>
#'   remove_directory_cnt("new_folder") |>
#'   list_content_cnt(pattern = "new_folder")
#'
#' @rdname remove_directory_cnt
#' @export
remove_directory_cnt.ConnectorFS <- function(connector_object, name, ...) {
  path <- file.path(
    connector_object$path,
    name
  )

  unlink(x = path, recursive = TRUE, ...)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses `read_cnt()` to allow redundancy between fs and dbi.
#'
#' @examples
#' # Use dplyr verbs on a table
#' cnt <- connector_fs(tempdir())
#'
#' cnt |>
#'   write_cnt(iris, "iris.csv")
#'
#' iris_cnt <- cnt |>
#'   tbl_cnt("iris.csv")
#'
#' iris_cnt
#'
#' iris_cnt |>
#'   dplyr::group_by(Species) |>
#'   dplyr::summarise(
#'     n = dplyr::n(),
#'     mean.Sepal.Length = mean(Sepal.Length, na.rm = TRUE)
#'   )
#'
#' @rdname tbl_cnt
#' @export
tbl_cnt.ConnectorFS <- function(connector_object, name, ...) {
  read_cnt(connector_object = connector_object, name = name, ...)
}
