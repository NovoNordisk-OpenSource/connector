#' Create a backend for the DBI (databases)
#'
#' @param yaml_content The yaml content
#' @param backend The backend to create and because of DBI, a "drv" is mandatory
#' @param name The name of the connection
#'
#'
#' @return A new backend based on R6 class
#' @export
#'
#' @importFrom purrr set_names map
#'
#' @examples
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
#' only_one <- extract_connections(yaml_content)[[2]]
#' ## Extract fct
#' my_backend <- only_one %>%
#'     extract_backends()
#' name <- only_one %>%
#'     extract_con()
#' # Create the backend
#' test <- create_backend_dbi(yaml_content = yaml_content, backend = my_backend, name = name)
create_backend_dbi <- function(yaml_content, backend, name) {
    if (is.null(backend$drv)) {
        stop("drv is a required field for dbi backend")
    }

    params_from_user <- backend[names(backend) != c("type")]

    # extract metadata if needed
    params_from_user <- purrr::map(params_from_user, function(x) {
        extract_custom_path(yaml_content, x)
    }) %>%
        purrr::set_names(names(params_from_user))


    connect_fct <- get_backend_fct(backend$type)

    # Extract driver
    params_from_user$drv <- get_backend_fct(backend$drv)()

    connect_ <- do.call(connect_fct, params_from_user)

    return(
        list(
            backend = connect_
        ) %>%
            purrr::set_names(name)
    )
}
