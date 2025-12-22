# TXT methods ----

#' @description
#' * `txt`: [readr::write_lines()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_character, S7::new_S3_class("txt"))) <- function(
    x,
    file,
    ...) {
  readr::write_lines(x = x, file = file, ...)
}


# CSV methods ----

#' @description
#' * `csv`: [readr::write_csv()]
#'
#' @param delim [character()] Delimiter to use. Default is `","`.
#'
#' @examples
#' # Write CSV file
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' write_file(iris, temp_csv)
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_data.frame, S7::new_S3_class("csv"))) <- function(
    x,
    file,
    delim = ",",
    ...) {
  readr::write_delim(x = x, file = file, delim = delim, ...)
}

# TSV methods ----

#' @description
#' * `tsv`: [readr::write_tsv()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_data.frame, S7::new_S3_class("tsv"))) <- function(
    x,
    file,
    ...) {
  readr::write_tsv(x = x, file = file, ...)
}


# parquet methods ----

#' @description
#' * `parquet`: [arrow::write_parquet()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_data.frame, S7::new_S3_class("parquet"))) <- function(
    x,
    file,
    ...) {
  arrow::write_parquet(x = x, sink = file, ...)
}


# RDS methods ----

#' @description
#' * `rds` (data.frame): [readr::write_rds()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_data.frame, S7::new_S3_class("rds"))) <- function(
    x,
    file,
    ...) {
  readr::write_rds(x = x, file = file, ...)
}

#' @description
#' * `rds` (list): [readr::write_rds()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_list, S7::new_S3_class("rds"))) <- function(
    x,
    file,
    ...) {
  readr::write_rds(x = x, file = file, ...)
}

#' @description
#' * `rds` (character): [readr::write_rds()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_character, S7::new_S3_class("rds"))) <- function(
    x,
    file,
    ...) {
  readr::write_rds(x = x, file = file, ...)
}

#' @description
#' * `rds` (numeric): [readr::write_rds()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_numeric, S7::new_S3_class("rds"))) <- function(
    x,
    file,
    ...) {
  readr::write_rds(x = x, file = file, ...)
}

#' @description
#' * `rds` (logical): [readr::write_rds()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_logical, S7::new_S3_class("rds"))) <- function(
    x,
    file,
    ...) {
  readr::write_rds(x = x, file = file, ...)
}

#' @description
#' * `rds` (matrix): [readr::write_rds()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::new_S3_class("matrix"), S7::new_S3_class("rds"))) <- function(
    x,
    file,
    ...) {
  readr::write_rds(x = x, file = file, ...)
}

#' @description
#' * `rds` (array): [readr::write_rds()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::new_S3_class("array"), S7::new_S3_class("rds"))) <- function(
    x,
    file,
    ...) {
  readr::write_rds(x = x, file = file, ...)
}


# XPT methods ----

#' @description
#' * `xpt`: [haven::write_xpt()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_data.frame, S7::new_S3_class("xpt"))) <- function(
    x,
    file,
    ...) {
  haven::write_xpt(data = x, path = file, ...)
}


# YAML methods ----

#' @description
#' * `yaml` (data.frame): [yaml::write_yaml()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_data.frame, S7::new_S3_class("yaml"))) <- function(
    x,
    file,
    ...) {
  yaml::write_yaml(x = x, file = file, ...)
}

#' @description
#' * `yaml` (list): [yaml::write_yaml()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_list, S7::new_S3_class("yaml"))) <- function(
    x,
    file,
    ...) {
  yaml::write_yaml(x = x, file = file, ...)
}

#' @description
#' * `yaml` (character): [yaml::write_yaml()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_character, S7::new_S3_class("yaml"))) <- function(
    x,
    file,
    ...) {
  yaml::write_yaml(x = x, file = file, ...)
}


# YML methods ----

#' @description
#' * `yml` (data.frame): [yaml::write_yaml()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_data.frame, S7::new_S3_class("yml"))) <- function(
    x,
    file,
    ...) {
  yaml::write_yaml(x = x, file = file, ...)
}

#' @description
#' * `yml` (list): [yaml::write_yaml()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_list, S7::new_S3_class("yml"))) <- function(
    x,
    file,
    ...) {
  yaml::write_yaml(x = x, file = file, ...)
}

#' @description
#' * `yml` (character): [yaml::write_yaml()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_character, S7::new_S3_class("yml"))) <- function(
    x,
    file,
    ...) {
  yaml::write_yaml(x = x, file = file, ...)
}


# JSON methods ----

#' @description
#' * `json` (data.frame): [jsonlite::write_json()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_data.frame, S7::new_S3_class("json"))) <- function(
    x,
    file,
    ...) {
  jsonlite::write_json(x = x, path = file, ...)
}

#' @description
#' * `json` (list): [jsonlite::write_json()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_list, S7::new_S3_class("json"))) <- function(
    x,
    file,
    ...) {
  jsonlite::write_json(x = x, path = file, ...)
}

#' @description
#' * `json` (character): [jsonlite::write_json()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_character, S7::new_S3_class("json"))) <- function(
    x,
    file,
    ...) {
  jsonlite::write_json(x = x, path = file, ...)
}


# Excel methods ----

#' @description
#' * `excel`: [writexl::write_xlsx()]
#'
#' @rdname write_file
#' @name write_ext
#' @export
S7::method(write_ext, list(S7::class_data.frame, S7::new_S3_class("xlsx"))) <- function(
    x,
    file,
    ...) {
  writexl::write_xlsx(x = x, path = file, ...)
}


