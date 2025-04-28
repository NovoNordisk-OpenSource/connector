#' Create a backend for the DBI (databases)
#'
#' @param backend The backend to create and because of DBI, a "drv" is mandatory
#' @return A new backend based on R6 class
#' @noRd
create_backend_dbi <- function(backend) {
  if (is.null(backend$drv)) {
    cli::cli_abort("drv is a required field for dbi backend")
  }

  create_backend(backend)
}
