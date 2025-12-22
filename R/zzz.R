#' @importFrom rlang on_load run_on_load
on_load(S7::methods_register())

.onLoad <- function(...) {
  run_on_load()
}
