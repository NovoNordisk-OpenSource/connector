#' Create a backend
#'
#' @param yaml_content The yaml content
#' @param backend The backend to create
#' @param name The name of the connection
#'
#'
#' @return A new backend based on R6 class
#' @export
#'
#' @importFrom purrr set_names map
#'
#' @examples
#' yaml_file <- system.file("config", "example_for_generic.yml", package = "connector")
#' yaml_content <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
#' only_one <- extract_connections(yaml_content)[[1]]
#' ## Extract fct
#' my_backend <- only_one %>%
#'     extract_backends()
#' name <- only_one %>%
#'     extract_con()
#' # Create the backend
#' test <- create_backend(yaml_content = yaml_content, backend = my_backend, name = name)
#'
create_backend <- function(yaml_content, backend, name) {
    params_from_user <- backend[names(backend) != c("type")]

    # extract metadata if needed
    params_from_user <- purrr::map(params_from_user, function(x) {
        extract_custom_path(yaml_content, x)
    }) %>%
        purrr::set_names(names(params_from_user))


    connect_fct <- get_backend_fct(backend$type)

    ## In case of db connection
    ## TODO: detect if a function is used for all params?
    if (!is.null(params_from_user$drv)) {
        params_from_user$drv <- get_backend_fct(backend$drv)()
    }

    connect_ <- try_connect(connect_fct, params_from_user)

    return(
        list(
            backend = connect_
        ) %>%
            purrr::set_names(name)
    )
}

#' Create a backend
#'
#' @param connect_fct The connection function
#' @param params_from_user  The parameters from the user
try_connect <- function(connect_fct, params_from_user) {
    connect_ <- try(do.call(connect_fct, params_from_user), silent = TRUE)

    if (inherits(connect_, "try-error")) {
        stop("Error in connection to the backend. Please check the parameters.")
    }

    return(connect_)
}
