#' @description
#' * [ConnectorFS]: Uses [read_file()] to read a given file.
#' The underlying function used, and thereby also the arguments available
#' through `...` depends on the file extension.
#'
#' @examples
#' # Write and read a CSV file using the file storage connector
#'
#' folder <- withr::local_tempdir()
#' cnt <- connector_fs(folder)
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
#'
#' folder <- withr::local_tempdir()
#' cnt <- connector_fs(folder)
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
write_cnt.ConnectorFS <- function(
    connector_object,
    x,
    name,
    overwrite = zephyr::get_option("overwrite", "connector"),
    ...) {
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
#' * [ConnectorFS]: Uses [fs::file_delete()] to delete the file.
#'
#' @examples
#' # Remove a file from the file storage
#'
#' folder <- withr::local_tempdir()
#' cnt <- connector_fs(folder)
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

  fs::file_delete(path = path)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [fs::file_copy()] to copy a file from the file storage
#' to the desired `file`.
#'
#' @examples
#' # Download file from a file storage
#'
#' folder <- withr::local_tempdir()
#' cnt <- connector_fs(folder)
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

  fs::file_copy(path = name, new_path = file, ...)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [fs::file_copy()] to copy the `file` to the file storage.
#'
#' @examples
#' # Upload file to a file storage
#'
#' writeLines("this is an example", "example.txt")
#'
#' folder <- withr::local_tempdir()
#' cnt <- connector_fs(folder)
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
    overwrite = zephyr::get_option("overwrite", "connector"),
    ...) {
  name <- file.path(connector_object$path, name)

  fs::file_copy(path = file, new_path = name, overwrite = overwrite)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [fs::dir_create()] to create a directory at the path of the connector.
#' @examples
#' # Create a directory in a file storage
#'
#' folder <- withr::local_tempdir()
#' cnt <- connector_fs(folder)
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
    open = TRUE,
    ...) {
  path <- file.path(connector_object$path, name)

  fs::dir_create(path = path, ...)

  # create a new connector object from the new path with persistent extra class
  if (open) {
    extra_class <- class(connector_object)
    extra_class <- utils::head(extra_class, which(extra_class == "ConnectorFS") - 1)
    connector_object <- connector_fs(path, extra_class)
  }

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [fs::dir_delete()] to remove a directory at the path of the connector.
#'
#' @examples
#' # Remove a directory from a file storage
#'
#' folder <- withr::local_tempdir()
#' cnt <- connector_fs(folder)
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

  fs::dir_delete(path = path)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [fs::dir_copy()].
#'
#' @rdname upload_directory_cnt
#' @export
upload_directory_cnt.ConnectorFS <- function(
    connector_object,
    dir,
    name,
    overwrite = zephyr::get_option("overwrite", "connector"),
    open = FALSE,
    ...) {
  name <- file.path(connector_object$path, name)

  fs::dir_copy(path = dir, new_path = name, overwrite = overwrite)

  # create a new connector object from the new path with persistent extra class
  if (open) {
    extra_class <- class(connector_object)
    extra_class <- utils::head(extra_class, which(extra_class == "ConnectorFS") - 1)
    connector_object <- connector_fs(name, extra_class)
  }

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses [fs::dir_copy()].
#'
#' @rdname download_directory_cnt
#' @export
download_directory_cnt.ConnectorFS <- function(connector_object, name, dir = basename(name), ...) {
  name <- file.path(connector_object$path, name)

  fs::dir_copy(path = name, new_path = dir, ...)

  return(
    invisible(connector_object)
  )
}

#' @description
#' * [ConnectorFS]: Uses `read_cnt()` to allow redundancy between fs and dbi.
#'
#' @examples
#' # Use dplyr verbs on a table
#'
#' folder <- withr::local_tempdir()
#' cnt <- connector_fs(folder)
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
