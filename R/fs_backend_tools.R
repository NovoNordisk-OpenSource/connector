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


#' Check if the path is a custom path to pass to glue
#'
#' @param path The path to check
#'
#' @return A boolean
#'
custom_path_or_not <- function(path) {
  # Check if the path is a custom path
  grepl(x = path, pattern = "\\{")
}

#' Extract information from metadata
#'
#' @param extracted_metadata The metadata extracted from the yaml file
#' @param path The path to extract information from
#'
#' @return The information extracted
#'
#' @importFrom stringr str_extract_all str_detect
#'

extract_info_from_metadata <- function(extracted_metadata, path) {
  extracted_infos <- str_extract_all(path, "(?<=\\{)(.*?)(?=\\})") %>%
    unlist()

  ## only metadata for now
  be_sure_metadata <- all(extracted_infos %>%
    str_detect("^metadata\\."))

  if (!be_sure_metadata) {
    stop("Only metadata is allowed for now in custom variables.")
  }

  ## Extract metadata
  metadata_ <- unlist(extracted_metadata)

  infos <- metadata_[extracted_infos]
  return(infos)
}

#' Extract custom path from metadata information if needed
#'
#' @param yaml_content  The yaml content
#' @param path The path to extract
#'
#' @return The custom path
#' @importFrom glue glue
extract_custom_path <- function(yaml_content, path) {
  tested_path <- custom_path_or_not(path)

  if (tested_path) {
    extracted_metadata <- yaml_content["metadata"] # list of list to unlist with points
    infos_path <- extract_info_from_metadata(extracted_metadata, path)

    custom_path <- glue::glue(
      path,
      .open = "{",
      .close = "}",
      .envir = as.list(infos_path) %>% list2env()
    )
  } else {
    custom_path <- path
  }

  return(custom_path)
}

#' Create a backend for the file system
#'
#' @param yaml_content The yaml content
#' @param backend The backend to create and because of file system, a "path" is mandatory
#' @param name The name of the connection
#'
#'
#' @return A new backend based on R6 class
#' @export
#'
#' @importFrom purrr set_names
#'
#' @examples
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
#' only_one <- extract_connections(yaml_content)[[1]]
#' ## Extract fct
#' my_backend <- only_one %>%
#'   extract_backends()
#' name <- only_one %>%
#'   extract_con()
#' # Create the backend
#' test <- create_backend_fs(yaml_content = yaml_content, backend = my_backend, name = name)
create_backend_fs <- function(yaml_content, backend, name) {
  params_from_user <- backend[names(backend) != c("type")]

  if (!("path" %in% names(backend))) {
    stop("Path is mandatory for connector_fs")
  }

  # extract metadata if needed
  params_from_user <- purrr::map(params_from_user, function(x) {
    extract_custom_path(yaml_content, x)
  }) %>%
    purrr::set_names(names(params_from_user))

  connect_fct <- get_backend_fct(backend$type)

  connect_ <- do.call(connect_fct, params_from_user)

  return(
    list(
      backend = connect_
    ) %>%
      purrr::set_names(name)
  )
}
