# DBI connection

connector_dbi <- R6::R6Class("connector_dbi",
  public = list(
    initialize = function(con) {
      self$con <- con
    },
    con = NULL
  )
)
