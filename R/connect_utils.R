#' Update a part of a list field
#'
#' @param old_metadata [list] a list of element to be replace
#' @param new_metadata [list] a list of element to replace old's
#'
#' @return [list] a updated list with new data
#' @noRd
change_to_new_metadata <- function(old_metadata, new_metadata) {
  # check params
  checkmate::assert_list(old_metadata, names = "unique", null.ok = TRUE)
  checkmate::assert_list(new_metadata, names = "unique")

  field_to_replace <- names(new_metadata)

  # for loop to change in place
  for (i in field_to_replace) {
    old_metadata[i] <- new_metadata[i]
  }

  return(old_metadata)
}
