#' Create a backend for the file system
#'
#' @param backend The backend to create and because of file system, a "path" is mandatory
#' @return A new backend based on R6 class
#' @noRd
create_backend_fs <- function(backend) {
  if (!("path" %in% names(backend))) {
    cli::cli_abort("Path is mandatory for ConnectorFS")
  }

  create_backend(backend)
}
