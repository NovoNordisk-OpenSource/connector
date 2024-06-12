#' A Connector object, a special list with R6 objects.
#' @param ... Arguments to pass to the connector
#' @export
Connector <- function(...) {
  structure(

    ...,
    class = c("Connector")
  )
}


#' Create a connection object depending on the backend type
#'
#' @param config The yaml content for a single connection
#' @noRd
create_connection <- function(config) {
  switch(config$backend$type,
    "connector_fs" = create_backend_fs(config$backend),
    "connector_dbi" = create_backend_dbi(config$backend),
    {
      zephyr::msg("Using generic backend connection for con: {config$con}")
      create_backend(config$backend)
    }
  )
}


#' Connect datasources to the connections from the yaml content
#'
#' @param yaml_content The yaml content
#'
#' @return A Connector object
#' @export
#'
#' @examples
# # read yaml file
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- read_yaml_config(yaml_file)
#' # create the connections
#' connect <- connect_from_yaml(yaml_content)
connect_from_yaml <- function(yaml_content) {
  connections <- yaml_content$connections |>
    purrr::map(create_connection) |>
    rlang::set_names(purrr::map_chr(yaml_content$connections, list("con", 1)))

  connector_ <- yaml_content$datasources |>
    purrr::map(\(x) connections[[x$con]]) %>%
    rlang::set_names(purrr::map_chr(yaml_content$datasources, list("name", 1)))

  Connector(
    connector_
  )
}
