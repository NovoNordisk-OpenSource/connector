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
#' @param yaml_content The yaml content
#' @param connection The connection object from the yaml
#'
create_connection <- function(yaml_content, connection) {
  ## TODO: should be better then that S3 method ?
  if (connection$backend$type == "connector_fs") {
    return(
      create_backend_fs(yaml_content, connection$backend, connection$con)
    )
  } else if (connection$backend$type == "connector_dbi") {
    return(
      create_backend_dbi(yaml_content, connection$backend, connection$con)
    )
  } else {
    message("Using generic backend connection")
    return(
      create_backend(yaml_content, connection$backend, connection$con)
    )
  }
}


#' Create all connections from the yaml content
#'
#' @param yaml_content The yaml content
#'
get_connections <- function(yaml_content) {
  connections <- extract_connections(yaml_content)

  purrr::map(connections, ~ create_connection(yaml_content, .x)) %>%
    purrr::flatten()
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
  ## extract datasources
  datasources <- extract_datasources(yaml_content)
  connections <- get_connections(yaml_content)

  connector_ <- purrr::map(datasources, function(x) {
    connections[[x$con]]
  }) %>%
    purrr::set_names(map(datasources, ~ .x$name))

  Connector(
    connector_
  )
}
