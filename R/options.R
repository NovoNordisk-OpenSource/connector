#' @eval options::as_roxygen_docs()
NULL

#' Internal reuse of options description
#' @eval options::as_params()
#' @name options_params
#' @keywords internal
#'
NULL

options::define_option(
  option = "verbosity_level",
  default = "verbose",
  desc = "How chatty should the log be? Possibilities are `quiet`, `verbose`, and `debug`."
)
