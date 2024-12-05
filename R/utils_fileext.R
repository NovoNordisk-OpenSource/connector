# Getting file extension
get_file_ext <- function(file_paths) {
  vapply(
    X = file_paths,
    FUN = function(file_path) {
      file_name <- basename(file_path)
      file_parts <- strsplit(file_name, "\\.")[[1]]
      file_extension <- ifelse(length(file_parts) == 1, "", utils::tail(file_parts, 1))
      return(file_extension)
    },
    FUN.VALUE = character(1),
    USE.NAMES = FALSE
  )
}
