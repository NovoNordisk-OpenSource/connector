#' Special list of connectors
#' @param ... Named individual [connector] objects
#' @examples
#' # Temp directories for two different folders
#'
#' path_sdtm <- tempdir()
#' path_adam <- tempdir()
#'
#' # Create connectors objects
#'
#' con <- connectors(
#'   sdtm = connector_fs$new(path = path_sdtm),
#'   adam = connector_fs$new(path = path_adam)
#' )
#'
#' # Print for overview
#'
#' con
#'
#' # Print the individual connector for more information
#'
#' con$sdtm
#'
#' @export
connectors <- function(...) {
  x <- rlang::list2(...)
  checkmate::assert_list(x = x, names = "named")
  structure(
    x,
    class = c("connectors")
  )
}

#' @export
print.connectors <- function(x) {
  classes <- x |>
    lapply(\(x) class(x)[[1]]) |>
    unlist()

  classes <- glue::glue(
    "${{names(classes)}} {.cls {{classes}}}",
    .open = "{{", .close = "}}"
  ) |>
    as.character() |>
    rlang::set_names(" ")

  cli::cli_bullets(
    c(
      "{.cls {class(x)}}",
      classes
    )
  )
  return(invisible(x))
}

#' Connect to datasources specified in config file
#' @param config [character] path to a connector config file or a [list] of specifications
#' @return [connectors]
#' @examples
#' config <- system.file("config", "default_config.yml", package = "connector")
#' con <- connect(config)
#' con
#' @export

connect <- function(config = "_connector.yml") {

  if (!is.list(config)) {
    config <- read_file(config)
  }

  config |>
    assert_config() |>
    connect_from_config()
}


#' Create a connection object depending on the backend type
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
#' @param config [list] The yaml content
#' @return A [connectors] object
#' @examples
# # read yaml file
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- read_yaml_config(yaml_file)
#' # create the connections
#' connect <- connect_from_yaml(yaml_content)
#' @noRd
connect_from_config <- function(config) {
  connections <- config$connections |>
    purrr::map(create_connection) |>
    rlang::set_names(purrr::map_chr(config$connections, list("con", 1)))

  connector_ <- config$datasources |>
    purrr::map(\(x) connections[[x$con]]) %>%
    rlang::set_names(purrr::map_chr(config$datasources, list("name", 1)))

  connectors(
    connector_
  )
}
