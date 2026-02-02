test_that("write_datasources works correctly", {
  # Create test connector object
  test_connectors <- connect(yaml_file)

  # Setup
  valid_extensions <- c("yml", "yaml", "json", "rds")
  temp_files <- purrr::map_chr(
    valid_extensions,
    ~ tempfile(fileext = paste0(".", .x))
  ) |>
    purrr::set_names(valid_extensions)
  temp_invalid <- tempfile(fileext = ".txt")

  # Test valid file extensions
  purrr::walk(
    temp_files,
    ~ expect_no_error(write_datasources(test_connectors, .x))
  )
  # Test file content
  original_sources <- list_datasources(test_connectors)
  written_sources <- read_file(temp_files["yml"])
  written_sources <- datasources(written_sources[["datasources"]])
  expect_equal(original_sources, written_sources)

  # Cleanup
  unlink(c(temp_files, temp_invalid))
})
