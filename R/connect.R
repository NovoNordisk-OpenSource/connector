#' Connect to datasources specified in a config file
#'
#' @description
#' Based on a configuration file or list this functions creates a [connectors()] object with
#' a [connector] for each of the specified datasources.
#'
#' The configuration file can be in any format that can be read through [read_file()], and
#' contains a list. If a yaml file is provided, expressions are evaluated when parsing it
#' using [yaml::read_yaml()] with `eval.expr = TRUE`.
#'
#' See also `vignette("connector")` on how to use configuration files in your project,
#' details below for the required structure of the configuration.
#'
#' @details
#' The input list can be specified in two ways:
#' 1. A named list containing the specifications of a single [connectors] object.
#' 1. An unnamed list, where each element is of the same structure as in 1., which
#' returns a nested [connectors] object. See example below.
#'
#' Each specification of a single [connectors]  have to have the following structure:
#'
#' * Only name, metadata, env and datasources are allowed.
#' * All elements must be named.
#' * **name** is only required when using nested connectors.
#' * **datasources** is mandatory.
#' * **metadata** and **env** must each be a list of named character vectors of length 1 if specified.
#' * **datasources** must each be a list of unnamed lists.
#' * Each datasource must have the named character element **name** and the named list element **backend**
#' * For each connection **backend**.**type** must be provided
#'
#' @param config [character] path to a connector config file or a [list] of specifications
#' @param metadata [list] Replace, add or create elements to the metadata field found in config
#' @param datasource [character] Name(s) of the datasource(s) to connect to.
#' If `NULL` (the default) all datasources are connected.
#' @param set_env [logical] Should environment variables from the yaml file be set? Default is TRUE.
#' @param logging [logical] Add logs to the console as well as to the whirl log html files. See details with this vignette.
#' @return [connectors]
#'
#' @examples
#' config <- system.file("config", "default_config.yml", package = "connector")
#'
#' config
#'
#' # Show the raw configuration file
#' readLines(config) |>
#'   cat(sep = "\n")
#'
#' # Connect to the datasources specified in it
#' cnts <- connect(config)
#' cnts
#'
#' # Content of each connector
#'
#' cnts$adam
#' cnts$sdtm
#'
#' # Overwrite metadata informations
#'
#' connect(config, metadata = list(extra_class = "my_class"))
#'
#' # Connect only to the adam datasource
#'
#' connect(config, datasource = "adam")
#'
#' # Connect to several projects in a nested structure
#'
#' config_nested <- system.file("config", "_connector_nested.yml", package = "connector")
#'
#' readLines(config_nested) |>
#'   cat(sep = "\n")
#'
#' cnts_nested <- connect(config_nested)
#'
#' cnts_nested
#'
#' cnts_nested$study1
#' @export

connect <- function(config = "_connector.yml", metadata = NULL, datasource = NULL, set_env = TRUE, logging = FALSE) {
  ## Check params
  checkmate::assert_list(metadata, names = "unique", null.ok = TRUE)
  checkmate::assert_logical(logging)

  if (!is.list(config)) {
    if (tools::file_ext(config) %in% c("yml", "yaml")) {
      config <- read_file(config, eval.expr = TRUE)
    } else {
      config <- read_file(config)
    }
  }

  if (is.null(names(config))) {
    names(config) <- purrr::map(config, "name")
    cnts <- config |>
      purrr::map(\(x) connect(x, metadata, datasource, set_env))

    return(do.call(nested_connectors, cnts))
  }

  # Replace metadata if needed
  if (!is.null(metadata)) {
    zephyr::msg(
      c("Replace some metadata informations...")
    )
    config[["metadata"]] <- change_to_new_metadata(
      old_metadata = config[["metadata"]],
      new_metadata = metadata
    )
  }

  connections <- config |>
    assert_config() |>
    parse_config(set_env = set_env) |>
    filter_config(datasource = datasource) |>
    connect_from_config()

  if (logging) {
    add_logs(connections)
  }

  connections
}

#' Connect datasources to the connections from the yaml content
#' @noRd
connect_from_config <- function(config) {
  connections <- config$datasources |>
    purrr::map(create_connection) |>
    rlang::set_names(purrr::map_chr(config$datasources, list("name", 1)))

    ## clean datasources
    # unlist name of datasource
  for(i in seq_along(config$datasources)){
    config$datasources[[i]]$name <- config$datasources[[i]]$name[[1]]
  }

  connections$datasources <- as_datasources(config["datasources"])

  do.call(what = connectors, args = connections)
}

#' @noRd
info_config <- function(config) {
  msg_ <- c(
    ">" = "{.strong {config$name}}",
    "*" = "{config$backend$type}",
    "*" = "{config$backend[!names(config$backend) %in% 'type']}"
  )

  cli::cat_rule()
  zephyr::msg(
    c(
      "Connection to:",
      msg_
    ),
    msg_fun = cli::cli_bullets
  )
}

#' Create a connection object depending on the backend type
#' @param config [list] The configuration of a single connection
#' @noRd
create_connection <- function(config) {
  info_config(config)

  switch(config$backend$type,
    "connector_fs" = {
      create_backend_fs(config$backend)
    },
    "connector_dbi" = {
      create_backend_dbi(config$backend)
    },
    {
      create_backend(config$backend)
    }
  )
}

#' Parse a configuration list and set environment variables if needed
#' @param config [list] Of unparsed configurations
#' @param set_env [logical] Should environment variables from the yaml file be set. Default is TRUE.
#' @return Configuration [list] with all content evaluated
#' @examples
#' config <- system.file("config", "test_env_config.yml", package = "connector") |>
#'   read_file()
#'
#' str(config)
#'
#' config |>
#'   parse_config() |>
#'   str()
#'
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

  config[["datasources"]] <- config[["datasources"]] |>
    parse_config_helper(input = list(env = env, metadata = config[["metadata"]]))

  return(config)
}

#' Filter config to only use the specified datasource
#' @noRd
filter_config <- function(config, datasource) {
  if (is.null(datasource)) {
    return(config)
  }

  config[["datasources"]] <- config[["datasources"]] |>
    purrr::keep(\(x) x[["name"]] %in% datasource)

  return(config)
}

#' Config input validation. See [connect()] for details.
#' @noRd
assert_config <- function(config, env = parent.frame()) {
  val <- checkmate::makeAssertCollection()

  checkmate::assert_list(x = config, names = "unique", add = val)

  checkmate::assert_names(
    x = names(config),
    type = "unique",
    subset.of = c("name", "metadata", "env", "datasources"),
    must.include = c("datasources"),
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
    x = config[["datasources"]],
    null.ok = FALSE,
    .var.name = "datasources",
    add = val
  )

  purrr::walk2(
    .x = config[["datasources"]],
    .y = seq_along(config[["datasources"]]),
    .f = \(x, y) {
      var <- paste0("datasources", y)
      checkmate::assert_list(x, .var.name = var, add = val)
      checkmate::assert_names(names(x),
        type = "unique", must.include = c("name", "backend"),
        .var.name = var, add = val
      )
      checkmate::assert_character(x[["name"]],
        len = 1,
        .var.name = paste0(var, ".name"), add = val
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

  zephyr::report_checkmate_assertions(
    collection = val,
    message = "Invalid configuration file:",
    .envir = env
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
