# Create a connector_fs object with a temporary folder path
normalized_temp_dir <- normalizePath(tempdir(), winslash = "/", mustWork = FALSE)
fs_connector <- connector::connector_fs$new(
  path = normalized_temp_dir,
  extra_class = "connector_logger"
)

test_that("log_read_connector.connector_fs logs correct message", {
  skip_if_not_installed("whirl")

  # Capture the log output
  log_output <- capture.output({
    log_read_connector.connector_fs(fs_connector, "test.csv")
  })

  # Verify the correct message was logged
  expected_msg <- glue::glue("test.csv @ {normalized_temp_dir}")
  expect_true(any(grepl(expected_msg, log_output, fixed = TRUE)))
})

test_that("log_write_connector.connector_fs logs correct message", {
  skip_if_not_installed("whirl")

  # Capture the log output
  log_output <- capture.output({
    log_write_connector.connector_fs(fs_connector, "test.csv")
  })

  # Verify the correct message was logged
  expected_msg <- glue::glue("test.csv @ {normalized_temp_dir}")
  expect_true(any(grepl(expected_msg, log_output, fixed = TRUE)))
})

test_that("log_remove_connector.connector_fs logs correct message", {
  skip_if_not_installed("whirl")

  # Capture the log output
  log_output <- capture.output({
    log_remove_connector.connector_fs(fs_connector, "test.csv")
  })

  # Verify the correct message was logged
  expected_msg <- glue::glue("test.csv @ {normalized_temp_dir}")
  expect_true(any(grepl(expected_msg, log_output, fixed = TRUE)))
})

test_that("connector_fs logging methods handle spaces in paths", {
  skip_if_not_installed("whirl")
  # Create a connector_fs object with path containing spaces
  fs_connector_spaces <- structure(
    list(path = file.path(normalized_temp_dir, "path with spaces")),
    class = "connector_fs"
  )

  # Capture the log output
  log_output <- capture.output({
    log_read_connector.connector_fs(fs_connector_spaces, "file with spaces.csv")
  })

  # Verify the correct message was logged
  expected_msg <- glue::glue(
    "file with spaces.csv @ {file.path(normalized_temp_dir, 'path with spaces')}"
  )
  expect_true(any(grepl(expected_msg, log_output, fixed = TRUE)))
})

test_that("connector_fs logging methods handle edge cases", {
  skip_if_not_installed("whirl")
  # Test with empty path
  fs_connector_empty_path <- structure(
    list(path = ""),
    class = "connector_fs"
  )

  # Capture the log output for empty path
  log_output_empty_path <- capture.output({
    log_read_connector.connector_fs(fs_connector_empty_path, "test.csv")
  })

  # Verify the correct message was logged
  expected_msg_empty_path <- "test.csv @ "
  expect_true(any(grepl(expected_msg_empty_path, log_output_empty_path, fixed = TRUE)))

  # Test with empty name
  log_output_empty_name <- capture.output({
    log_write_connector.connector_fs(fs_connector, "")
  })

  # Verify the correct message was logged
  expected_msg_empty_name <- glue::glue(" @ {normalized_temp_dir}")
  expect_true(any(grepl(expected_msg_empty_name, log_output_empty_name, fixed = TRUE)))
})
