#' Create a backend for the file system
#'
#' @param backend The backend to create and because of file system, a "path" is mandatory
#' @return A new backend based on R6 class
#' @export
#'
#' @importFrom purrr set_names
#'
#' @examples
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
#' only_one <- extract_connections(yaml_content)[[1]]
#' ## Extract fct
#' my_backend <- only_one %>%
#'   extract_backends()
#' name <- only_one %>%
#'   extract_con()
#' # Create the backend
#' test <- create_backend_fs(yaml_content = yaml_content, backend = my_backend, name = name)
create_backend_fs <- function(backend) {

  if (!("path" %in% names(backend))) {
    cli::cli_abort("Path is mandatory for connector_fs")
  }

  create_backend(backend)
}
