#' Add metadata to a YAML configuration file
#'
#' This function adds metadata to a YAML configuration file by modifying the provided
#' key-value pair in the metadata section of the file.
#'
#' @param config_path The file path to the YAML configuration file
#' @param key The key for the new metadata entry
#' @param value The value for the new metadata entry
#' @return (invisible) `config_path` where the configuration have been updated
#' @examples
#' config <- tempfile(fileext = ".yml")
#'
#' file.copy(
#'   from = system.file("config", "_connector.yml", package = "connector"),
#'   to = config
#' )
#'
#' config <- config |>
#'   add_metadata(
#'     key = "new_metadata",
#'     value = "new_value"
#'   )
#' config
#'
#' @export
add_metadata <- function(config_path, key, value) {
  checkmate::assert_file_exists(config_path)
  checkmate::assert_string(key)
  checkmate::assert_string(value)

  config <- read_file(config_path, eval.expr = TRUE)
  config$metadata[[key]] <- value
  write_file(x = config, file = config_path, overwrite = TRUE)
  return(invisible(config_path))
}

#' Remove metadata from a YAML configuration file
#'
#' This function removes metadata from a YAML configuration file by deleting
#' the specified key from the metadata section of the file.
#'
#' @param config_path The file path to the YAML configuration file
#' @param key The key for the metadata entry to be removed
#' @return (invisible) `config_path` where the configuration have been updated
#' @examples
#' config <- tempfile(fileext = ".yml")
#'
#' file.copy(
#'   from = system.file("config", "_connector.yml", package = "connector"),
#'   to = config
#' )
#' # Add metadata first
#' config <- config |>
#'   add_metadata(
#'     key = "new_metadata",
#'     value = "new_value"
#'   )
#' config
#' #' # Now remove it
#' config <- config |>
#'   remove_metadata("new_metadata")
#' config
#'
#' @export
remove_metadata <- function(config_path, key) {
  checkmate::assert_file_exists(config_path)
  checkmate::assert_string(key)

  config <- read_file(config_path, eval.expr = TRUE)
  config$metadata[[key]] <- NULL
  write_file(x = config, file = config_path, overwrite = TRUE)
  return(invisible(config_path))
}

#' Extract data sources from connectors
#'
#' This function extracts the "datasources" attribute from a connectors object.
#'
#' @param connectors An object containing connectors with a "datasources" attribute.
#'
#' @return An object containing the data sources extracted from the "datasources" attribute.
#'
#' @details
#' The function uses the `attr()` function to access the "datasources" attribute
#' of the `connectors` object. It directly returns this attribute without any
#' modification.
#'
#' @examples
#'
#' # Connectors object with data sources
#' cnts <- connectors(
#'   sdtm = connector_fs(path = tempdir()),
#'   adam = connector_dbi(drv = RSQLite::SQLite())
#' )
#'
#' # Using the function (returns datasources attribute)
#' result <- list_datasources(cnts)
#' # Check if result contains datasource information
#' result$datasources
#'
#' @name list_datasources
#' @export
list_datasources <- function(connectors) {
  if (!is_connectors(connectors)) {
    cli::cli_abort("param connectors should be a connectors object.")
  }

  ds <- attr(connectors, "datasources")
  ds
}

#' Previously used to extract data sources from connectors
#'
#' @description
#' `r lifecycle::badge("deprecated")`. Look for `[list_datasources()]` instead.
#'
#' @param connectors An object containing connectors with a "datasources" attribute.
#'
#' @export
datasources <- function(connectors) {
  lifecycle::deprecate_soft(
    when = "1.0.0",
    what = "connector::datasources()",
    with = "connector::list_datasources()"
  )
  list_datasources(connectors)
}

#' Add a new datasource to a YAML configuration file
#'
#' This function adds a new datasource to a YAML configuration file by appending the
#' provided datasource information to the existing datasources.
#'
#' @param config_path The file path to the YAML configuration file
#' @param name The name of the new datasource
#' @param backend A named list representing the backend configuration for the new datasource
#' @return (invisible) `config_path` where the configuration have been updated
#' @examples
#' config <- tempfile(fileext = ".yml")
#'
#' file.copy(
#'   from = system.file("config", "_connector.yml", package = "connector"),
#'   to = config
#' )
#'
#' config <- config |>
#'   add_datasource(
#'     name = "new_datasource",
#'     backend = list(type = "connector_fs", path = "new_path")
#'   )
#' config
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
  write_file(x = config, file = config_path, overwrite = TRUE)
  return(invisible(config_path))
}

#' Remove a datasource from a YAML configuration file
#'
#' This function removes a datasource from a YAML configuration file based on the
#' provided name, ensuring that it doesn't interfere with other existing datasources.
#'
#' @param config_path The file path to the YAML configuration file
#' @param name The name of the datasource to be removed
#' @return (invisible) `config_path` where the configuration have been updated
#'
#' @examples
#' config <- tempfile(fileext = ".yml")
#'
#' file.copy(
#'   from = system.file("config", "_connector.yml", package = "connector"),
#'   to = config
#' )
#' # Add a datasource first
#' config <- config |>
#'   add_datasource(
#'     name = "new_datasource",
#'     backend = list(type = "connector_fs", path = "new_path")
#'   )
#' config
#' # Now remove it
#' config <- config |>
#'   remove_datasource("new_datasource")
#' config
#' @export
remove_datasource <- function(config_path, name) {
  checkmate::assert_file_exists(config_path)
  checkmate::assert_string(name)

  config <- read_file(config_path, eval.expr = TRUE)
  config$datasources <- config$datasources[
    !(sapply(config$datasources, function(x) x$name) == name)
  ]
  write_file(x = config, file = config_path, overwrite = TRUE)
  return(invisible(config_path))
}


#' Extract metadata from connectors
#'
#' This function extracts the "metadata" attribute from a connectors object,
#' with optional filtering to return only a specific metadata field.
#'
#' @param connectors An object containing connectors with a "metadata" attribute.
#' @param name A character string specifying which metadata attribute to extract.
#'   If `NULL` (default), returns all metadata.
#'
#' @return A list containing the metadata extracted from the "metadata" attribute,
#'   or the specific attribute value if `name` is specified.
#'
#' @examples
#' # A config list with metadata
#' config <- list(
#'   metadata = list(
#'     study = "Example Study",
#'     version = "1.0"
#'   ),
#'   datasources = list(
#'     list(
#'       name = "adam",
#'       backend = list(type = "connector_fs", path = tempdir())
#'     )
#'   )
#' )
#'
#' cnts <- connect(config)
#'
#' # Extract all metadata
#' result <- extract_metadata(cnts)
#' print(result)
#'
#' # Extract specific metadata field
#' study_name <- extract_metadata(cnts, name = "study")
#' print(study_name)
#'
#' @export
extract_metadata <- function(connectors, name = NULL) {
  if (!is_connectors(connectors)) {
    cli::cli_abort("param connectors should be a connectors object.")
  }

  checkmate::assert_character(name, null.ok = TRUE)

  metadata <- attr(connectors, "metadata")

  if (!is.null(name)) {
    metadata <- metadata[[name]]
  }

  metadata
}
