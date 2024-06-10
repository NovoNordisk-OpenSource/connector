#' Read and parse yaml configuration file
#' @param file [character] Path to yaml file
#' @param eval.expr [logical] Evaluate expressions in yaml file. Passed to [yaml::read_yaml]
#' @param set_env [logical] Should environment variables from the yaml file be set. Default is TRUE.
#' @return Configuration [list] with all content evaluated
#' @examples
#' yaml_file <- system.file("config", "default_env_config.yml", package = "connector")
#' yaml::read_yaml(yaml_file, eval.expr = TRUE) |> str()
#' config <- read_yaml_config(yaml_file)
#' str(config)
#' Sys.getenv("hello")
#' @export

read_yaml_config <- function(file, eval.expr = TRUE, set_env = TRUE) {
  val <- checkmate::makeAssertCollection()
  checkmate::assert_file_exists(x = file, access = "r", add = val)
  checkmate::assert_logical(x = eval.expr, add = val)
  checkmate::assert_logical(x = set_env, add = val)
  zephyr::report_checkmate_assertations(collection = val)

  config <- yaml::read_yaml(file = file, eval.expr = eval.expr) |>
    assert_config()

  # Parse env variables

  env_old <- Sys.getenv(names = TRUE) |>
    as.list()

  config[["env"]] <- config[["env"]] |>
    parse_config(input = list(env = env_old))

  if (set_env && length(config[["env"]])) {
    do.call(what = Sys.setenv, args = config[["env"]])
    # TODO: Info on overwrite
    zephyr::msg("overwriting stuff")
  } else if (any(names(env_old) %in% names(config[["env"]]))) {
    # TODO: Alert if inconsistencies, if not overwrite
    zephyr::msg("inconsistencies", msg_fun = cli::cli_alert_warning)
  }

  env <- env_old[!names(env_old) %in% names(config[["env"]])] |>
    c(config[["env"]])

  # Parse other content in order

  config[["metadata"]] <- config[["metadata"]] |>
    parse_config(input = list(env = env))

  config[["connections"]] <- config[["connections"]] |>
    parse_config(input = list(env = env, metadata = config[["metadata"]]))

  config[["datasources"]] <- config[["datasources"]] |>
    parse_config(input = list(env = env, metadata = config[["metadata"]]))

  return(config)
}

#' @noRd

assert_config <- function(config) {
  # Input validation:
  #
  # - Only metadata, env, connections, and datasources are allowed
  # - Everything must be named
  # - connections and datasources are mandatory
  # - metadata and env must each be a list of named character vectors of length 1
  # - connections and datasources must each be a list of unnamed lists
  # - each connection must have the named character element "con" and the named list element "backend"
  # - each datasource must have the named character element "name"

  # TODO: Implement all of the above

  val <- checkmate::makeAssertCollection()

  checkmate::assert_list(x = config, names = "unique", add = val)
  checkmate::assert_names(
    x = names(config),
    type = "unique",
    subset.of = c("metadata", "env", "connections", "datasources"),
    must.include = c("connections", "datasources"),
    what = "index",
    .var.name = "yaml",
    add = val
  )

  zephyr::report_checkmate_assertations(collection = val, msg = "Invalid configuration file:")

  return(invisible(config))
}

#' @noRd

parse_config <- function(content, input) {
  if (is.null(content)) {
    return(NULL)
  }

  env <- unlist(input, recursive = FALSE)

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
      glue::glue(..., .envir = .envir) |>
      as.character()
  } else {
    x
  }
}
