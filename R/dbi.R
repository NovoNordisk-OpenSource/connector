# DBI connection

connector_dbi <- R6::R6Class("connector_dbi",
  public = list(
    initialize = function(con) {
      self$con <- con
    },
    con = NULL
  )
)


#' @export

connector_dbi.read <- function(...) {
  DBI::dbReadTable(...)
}

#' @export

connector_dbi.write <- function(...) {
  DBI::dbWriteTable(...)
}
