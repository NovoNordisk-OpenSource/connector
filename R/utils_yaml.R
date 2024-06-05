#' Extract an element from a yaml content
#' @param yaml_content The yaml content
#' @param element The element to extract
#' @return The element extracted
#' @export
#' @examples
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
#' extract_element(yaml_content, "metadata")
#' @name extract_element

extract_element <- function(yaml_content, element) {
    yaml_content[[element]]
}

#' @title Extract metadata from a yaml file
#' @description Extract metadata from a yaml file
#'
#' @rdname extract_element
#'
#' @param yaml_content The yaml content
#' @return The metadata extracted
#'
#' @export
#' @examples
#' yaml_file <- system.file("config", "default_config.yml", package = "connector")
#' yaml_content <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
#' extract_metadata(yaml_content)
extract_metadata <- function(yaml_content) {
    extract_element(yaml_content, "metadata")
}

#' @rdname extract_element
#' @export
extract_connections <- function(yaml_content) {
    extract_element(yaml_content, "connections")
}
#' @rdname extract_element
#' @export
extract_datasources <- function(yaml_content) {
    extract_element(yaml_content, "datasources")
}
#' @rdname extract_element
#' @export
extract_backends <- function(yaml_content) {
    extract_element(yaml_content, "backend")
}
#' @rdname extract_element
#' @export
extract_con <- function(yaml_content) {
    extract_element(yaml_content, "con")
}
