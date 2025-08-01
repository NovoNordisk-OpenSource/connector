# Minimal prints to make it easier to read test output
withr::local_options(
  .new = list(
    connector.verbosity_level = "quiet",
    whirl.verbosity_level = "quiet",
    readr.show_col_types = FALSE
  ),
  .local_envir = teardown_env()
)

withr::defer(
  unlink(temp_dir, recursive = TRUE),
  teardown_env()
)
