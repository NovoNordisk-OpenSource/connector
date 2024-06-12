#' Create a backend for the DBI (databases)
#'
#' @param backend The backend to create and because of DBI, a "drv" is mandatory
#' @return A new backend based on R6 class
#' @export
#' @examples
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- read_yaml_config(yaml_file)
#'
#' only_one <- yaml_content[["connections"]][[2]][["backend"]]
#'
#' test <- create_backend_dbi(only_one)
#'
create_backend_dbi <- function(backend) {
    if (is.null(backend$drv)) {
        cli::cli_abort("drv is a required field for dbi backend")
    }

    create_backend(backend)
}
