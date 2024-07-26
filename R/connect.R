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
    parse_config() |>
    connect_from_config()
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

  do.call(what = connectors, args = connector_)
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

#' Read and parse yaml configuration file
#' @param file [character] Path to yaml file
#' @param set_env [logical] Should environment variables from the yaml file be set. Default is TRUE.
#' @return Configuration [list] with all content evaluated
#' @examples
#' yaml_file <- system.file("config", "test_env_config.yml", package = "connector")
#' yaml::read_yaml(yaml_file, eval.expr = TRUE) |> str()
#' config <- read_yaml_config(yaml_file)
#' str(config)
#' Sys.getenv("hello")
#' @noRd

parse_config <- function(config, set_env = TRUE) {

  # Parse env variables

  env_old <- Sys.getenv(names = TRUE) |>
    as.list()

  config[["env"]] <- config[["env"]] |>
    parse_config_helper(input = list(env = env_old))

  if (set_env && length(config[["env"]])) {
    do.call(what = Sys.setenv, args = config[["env"]])
  }

  if (any(names(env_old) %in% names(config[["env"]]))) {
    nm <- intersect(names(env_old), names(config[["env"]]))

    # Info on overwrite, and alert if inconsistencies, and not overwrite

    if (set_env) {
      c(
        "!" = "Overwriting already set environment variables:",
        rlang::set_names(nm, "*"),
        "i" = "To revert back to the original values restart your R session"
      ) |>
        zephyr::msg(msg_fun = cli::cli_bullets)
    } else {
      c(
        "!" = "Inconsistencies between existing environment variables and env entries:",
        rlang::set_names(nm, "*")
      ) |>
        zephyr::msg(msg_fun = cli::cli_bullets)
    }
  }

  env <- env_old[!names(env_old) %in% names(config[["env"]])] |>
    c(config[["env"]])

  # Parse other content in order

  config[["metadata"]] <- config[["metadata"]] |>
    parse_config_helper(input = list(env = env))

  config[["connections"]] <- config[["connections"]] |>
    parse_config_helper(input = list(env = env, metadata = config[["metadata"]]))

  config[["datasources"]] <- config[["datasources"]] |>
    parse_config_helper(input = list(env = env, metadata = config[["metadata"]]))

  return(config)
}

#' Input validation:
#'
#' - Only metadata, env, connections, and datasources are allowed
#' - Everything must be named
#' - connections and datasources are mandatory
#' - metadata and env must each be a list of named character vectors of length 1
#' - connections and datasources must each be a list of unnamed lists
#' - each connection must have the named character element "con" and the named list element "backend"
#' - each datasource must have the named character element "name"
#' - for each connection backend.type must be provided
#' @noRd

assert_config <- function(config, env = parent.frame()) {
  val <- checkmate::makeAssertCollection()

  checkmate::assert_list(x = config, names = "unique", add = val)

  checkmate::assert_names(
    x = names(config),
    type = "unique",
    subset.of = c("metadata", "env", "connections", "datasources"),
    must.include = c("connections", "datasources"),
    what = "Config",
    .var.name = "yaml",
    add = val
  )

  checkmate::assert_list(
    x = config[["metadata"]],
    names = "unique",
    null.ok = TRUE,
    .var.name = "metadata",
    add = val
  )

  purrr::walk2(
    .x = config[["metadata"]],
    .y = names(config[["metadata"]]),
    .f = \(x, y) {
      checkmate::assert_character(x, len = 1, .var.name = paste0("metadata.", y), add = val)
    }
  )

  checkmate::assert_list(
    x = config[["env"]],
    names = "unique",
    null.ok = TRUE,
    .var.name = "env",
    add = val
  )

  purrr::walk2(
    .x = config[["env"]],
    .y = names(config[["env"]]),
    .f = \(x, y) {
      checkmate::assert_character(x, len = 1, .var.name = paste0("env.", y), add = val)
    }
  )

  checkmate::assert_list(
    x = config[["connections"]],
    null.ok = FALSE,
    .var.name = "connections",
    add = val
  )

  purrr::walk2(
    .x = config[["connections"]],
    .y = seq_along(config[["connections"]]),
    .f = \(x, y) {
      var <- paste0("connections.", y)
      checkmate::assert_list(x, .var.name = var, add = val)
      checkmate::assert_names(names(x),
                              type = "unique", must.include = c("con", "backend"),
                              .var.name = var, add = val
      )
      checkmate::assert_character(x[["con"]],
                                  len = 1,
                                  .var.name = paste0(var, ".con"), add = val
      )
      checkmate::assert_list(x[["backend"]],
                             names = "unique",
                             .var.name = paste0(var, ".backend"), add = val
      )
      checkmate::assert_character(x[["backend"]][["type"]],
                                  len = 1,
                                  .var.name = paste0(var, ".backend.type"), add = val
      )
    }
  )

  checkmate::assert_list(
    x = config[["datasources"]],
    null.ok = FALSE,
    .var.name = "datasources",
    add = val
  )

  purrr::walk2(
    .x = config[["datasources"]],
    .y = seq_along(config[["datasources"]]),
    .f = \(x, y) {
      var <- paste0("datasources.", y)
      checkmate::assert_list(x, .var.name = var, add = val)
      checkmate::assert_names(names(x), type = "unique", must.include = c("name"), .var.name = var, add = val)
      checkmate::assert_character(x[["name"]], len = 1, .var.name = paste0(var, ".name"), add = val)
    }
  )

  zephyr::report_checkmate_assertions(
    collection = val,
    msg = "Invalid configuration file:",
    env = env
  )

  return(invisible(config))
}

#' @noRd

parse_config_helper <- function(content, input) {
  if (is.null(content)) {
    return(NULL)
  }

  env <- unlist(input, recursive = FALSE) |>
    as.list() |>
    list2env()

  content |>
    purrr::map_depth(
      .depth = -1,
      .ragged = TRUE,
      .f = \(x) glue_if_character(x, .envir = env)
    )
}

#' @noRd

glue_if_character <- function(x, ..., .envir = parent.frame()) {
  if (is.character(x)) {
    x |>
      purrr::map_chr(\(x) glue::glue(x, ..., .envir = .envir))
  } else {
    x
  }
}
