#' Create a backend
#'
#' @param backend The backend to create
#'
#' @return A new backend based on R6 class
#' @export
#' @examples
#' yaml_file <- system.file("config", "example_for_generic.yml", package = "connector")
#' yaml_content <- read_yaml_config(yaml_file)
#'
#' only_one <- yaml_content[["connections"]][[1]][["backend"]]
#'
#' test <- create_backend(only_one)
#'
create_backend <- function(backend) {
  params_from_user <- backend[!names(backend) %in% c("type", "extra_class")]

  connector <- get_backend_fct(backend$type)

  if (R6::is.R6Class(connector)) {
    connect_fct <- connector$new
  } else {
    connect_fct <- connector
  }

  ## In case of db connection
  ## TODO: detect if a function is used for all params?
  if (!is.null(params_from_user$drv)) {
    params_from_user$drv <- get_backend_fct(backend$drv)()
  }

  connect_ <- try_connect(connect_fct, params_from_user)

  if (!is.null(backend$extra_class)) {
    class(connect_) <- c(backend$extra_class, class(connect_))
  }

  return(connect_)
}

#' Get the backend function
#'
#' @param backend_type The type of the backend, by default it is connector_fs or connector_db
#'
#' @return The backend function
#' @export
#'
#' @examples
#' get_backend_fct("connector_fs")
get_backend_fct <- function(backend_type) {
  defaults_backends <- getNamespaceExports("connector")[
    grepl("^connector_", getNamespaceExports("connector"))
  ]

  if (backend_type %in% defaults_backends) {
    return(
      getExportedValue("connector", backend_type)
    )
  } else {
    package_name <- gsub("\\:{2,3}[^\\:]+$", backend_type, replacement = "")
    function_name <- gsub("^.+\\:{2,3}|\\(\\)", "", backend_type)

    return(getExportedValue(package_name, function_name))
  }
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
