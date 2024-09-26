#' Create a backend for the DBI (databases)
#'
#' @param backend The backend to create and because of DBI, a "drv" is mandatory
#' @return A new backend based on R6 class
#' @noRd
#' @examples
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- yaml::read_yaml(yaml_file, eval.expr=TRUE)
#'
#' only_one <- yaml_content[["datasources"]][[2]][["backend"]]
#'
#' test <- create_backend_dbi(only_one)
#'
create_backend_dbi <- function(backend) {
  if (is.null(backend$drv)) {
    cli::cli_abort("drv is a required field for dbi backend")
  }

  create_backend(backend)
}
