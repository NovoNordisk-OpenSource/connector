#' list of implemented methods for a connector class
#' @noRd

list_methods <- function(connector_object) {
  classes <- class(connector_object)
  classes <- classes[classes != "R6"]

  info <- classes |>
    lapply(\(x) utils::methods(class = x)) |>
    lapply(attr, "info")

  info <- Reduce(f = rbind, x = info)
  info <- info[!duplicated(info$generic), ]

  rownames(info)
}
