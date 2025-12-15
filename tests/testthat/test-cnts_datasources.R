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
  written_sources <- as_datasources(written_sources)
  expect_equal(original_sources, written_sources)

  # Test invalid cases
  invalid_inputs <- list(
    list(
      input = list(dummy = "data"),
      file = temp_files["yml"],
      error = "param 'connectors' should be a connectors object"
    ),
    list(
      input = test_connectors,
      file = temp_invalid,
      error = "ext %in%"
    ),
    list(
      input = test_connectors,
      file = NULL,
      error = "Must be of type 'character'"
    ),
    list(
      input = test_connectors,
      file = NA_character_,
      error = "Contains missing values"
    )
  )

  purrr::walk(
    invalid_inputs,
    ~ expect_error(
      write_datasources(.x$input, .x$file),
      .x$error
    )
  )

  # Cleanup
  unlink(c(temp_files, temp_invalid))
})
