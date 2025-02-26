#' Create a backend for the file system
#'
#' @param backend The backend to create and because of file system, a "path" is mandatory
#' @return A new backend based on R6 class
#' @noRd
#' @examples
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
#'
#' only_one <- yaml_content[["datasources"]][[1]][["backend"]]
#'
#' test <- create_backend_fs(only_one)
#'
create_backend_fs <- function(backend) {
  if (!("path" %in% names(backend))) {
    cli::cli_abort("Path is mandatory for ConnectorFS")
  }

  create_backend(backend)
}
