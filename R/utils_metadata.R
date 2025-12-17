#' Propagate metadata from parent connector to child connector
#' @param parent_cnt [Connector] Parent connector object
#' @param child_cnt [Connector] Child connector object
#' @return Child connector with metadata attached
#' @noRd
propagate_metadata <- function(parent_cnt, child_cnt) {
  parent_metadata <- attr(parent_cnt, "metadata", exact = TRUE)

  if (!is.null(parent_metadata)) {
    attr(child_cnt, "metadata") <- parent_metadata
  }

  return(child_cnt)
}
