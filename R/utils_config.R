#' Add metadata to a YAML configuration file
#'
#' This function adds metadata to a YAML configuration file by modifying the provided key-value pair in the metadata section of the file.
#'
#' @param config_path The file path to the YAML configuration file
#' @param key The key for the new metadata entry
#' @param value The value for the new metadata entry
#' @return The updated configuration after adding the new metadata
#' @examples
#' # Read the YAML file
#' test_config <- system.file("config", "default_config.yml", package = "connector")
#' file.copy(test_config, "test_config.yaml")
#'
#' # Add metadata
#' config <- add_metadata("test_config.yaml", "new_metadata", "new_value")
#'
#' unlink("test_config.yaml)
#'
#' @export
add_metadata <- function(config_path, key, value) {
  checkmate::assert_file_exists(config_path)
  checkmate::assert_string(key)
  checkmate::assert_string(value)

  config <- read_file(config_path, eval.expr = TRUE)
  config$metadata[[key]] <- value
  write_file(config, config_path)
  return(config)
}

#' Remove metadata from a YAML configuration file
#'
#' This function removes metadata from a YAML configuration file by deleting the specified key from the metadata section of the file.
#'
#' @param config_path The file path to the YAML configuration file
#' @param key The key for the metadata entry to be removed
#' @return The updated configuration after removing the specified metadata
#' @examples
#' # Read the YAML file
#' test_config <- system.file("config", "default_config.yml", package = "connector")
#' file.copy(test_config, "test_config.yaml")
#'
#' # Add metadata
#' config <- add_metadata("test_config.yaml", "new_metadata", "new_value")
#'
#' # Remove metadata
#' config <- remove_metadata("test_config.yaml", "new_metadata")
#'
#' unlink("test_config.yaml)
#'
#' @export
remove_metadata <- function(config_path, key) {
  checkmate::assert_file_exists(config_path)
  checkmate::assert_string(key)

  config <- read_file(config_path, eval.expr = TRUE)
  config$metadata[[key]] <- NULL
  write_file(config, config_path)
  return(config)
}

#' Add a new datasource to a YAML configuration file
#'
#' This function adds a new datasource to a YAML configuration file by appending the
#' provided datasource information to the existing datasources.
#'
#' @param config_path The file path to the YAML configuration file
#' @param name The name of the new datasource
#' @param backend A named list representing the backend configuration for the new datasource
#' @return The updated configuration after adding the new datasource
#' @examples
#'
#' # Read the YAML file
#' test_config <- system.file("config", "default_config.yml", package = "connector")
#' file.copy(test_config, "test_config.yaml")
#'
#' # Add a new datasource
#' # Define the backend as a named list
#' new_backend <- list(
#'   type = "connector_jdbc",
#'   driver = "org.postgresql.Driver",
#'   url = "jdbc:postgresql://localhost:5432/mydatabase",
#'   user = "username",
#'   password = "password"
#' )
#'
#' # Add a new datasource with the defined backend
#' config <- add_datasource("test_config.yaml", "new_datasource", new_backend)
#'
#' unlink("test_config.yaml)
#'
#' @export
add_datasource <- function(config_path, name, backend) {
  checkmate::assert_file_exists(config_path)
  checkmate::assert_string(name)
  checkmate::assert_list(backend)

  config <- read_file(config_path, eval.expr = TRUE)
  new_datasource <- list(
    name = name,
    backend = backend
  )
  config$datasources <- c(config$datasources, list(new_datasource))
  write_file(config, config_path)
  return(config)
}

#' Remove a datasource from a YAML configuration file
#'
#' This function removes a datasource from a YAML configuration file based on the
#' provided name, ensuring that it doesn't interfere with other existing datasources.
#'
#' @param config_path The file path to the YAML configuration file
#' @param name The name of the datasource to be removed
#' @return The updated configuration after removing the specified datasource
#' # Read the YAML file
#' test_config <- system.file("config", "default_config.yml", package = "connector")
#' file.copy(test_config, "test_config.yaml")
#'
#' # Add a new datasource
#' # Define the backend as a named list
#' new_backend <- list(
#'   type = "connector_jdbc",
#'   driver = "org.postgresql.Driver",
#'   url = "jdbc:postgresql://localhost:5432/mydatabase",
#'   user = "username",
#'   password = "password"
#' )
#'
#' # Add a new datasource with the defined backend
#' config <- add_datasource("test_config.yaml", "new_datasource", new_backend)
#'
#' # Remove a datasource
#' config <- remove_datasource("test_config.yaml", "new_datasource")
#'
#' unlink("test_config.yaml)
#'
#' @export
remove_datasource <- function(config_path, name) {
  checkmate::assert_file_exists(config_path)
  checkmate::assert_string(name)

  config <- read_file(config_path, eval.expr = TRUE)
  config$datasources <- config$datasources[!(sapply(config$datasources, function(x) x$name) == name)]
  write_file(config, config_path)
  return(config)
}
