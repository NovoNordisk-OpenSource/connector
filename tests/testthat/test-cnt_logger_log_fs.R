# Create a connector_fs object with a temporary folder path
fs_connector <- connector::connector_fs$new(
  path = tempdir(),
  extra_class = "connector_logger"
)

test_that("log_read_connector.connector_fs logs correct message", {
  skip_if_not_installed("whirl")

  # Capture the log output
  log_output <- capture.output({
    log_read_connector.connector_fs(fs_connector, "test.csv")
  })

  # Verify the correct message was logged
  expected_msg <- glue::glue("test.csv @ {tempdir()}")
  expect_true(any(grepl(expected_msg, log_output)))
})

test_that("log_write_connector.connector_fs logs correct message", {
  skip_if_not_installed("whirl")

  # Capture the log output
  log_output <- capture.output({
    log_write_connector.connector_fs(fs_connector, "test.csv")
  })

  # Verify the correct message was logged
  expected_msg <- glue::glue("test.csv @ {tempdir()}")
  expect_true(any(grepl(expected_msg, log_output)))
})

test_that("log_remove_connector.connector_fs logs correct message", {
  skip_if_not_installed("whirl")

  # Capture the log output
  log_output <- capture.output({
    log_remove_connector.connector_fs(fs_connector, "test.csv")
  })

  # Verify the correct message was logged
  expected_msg <- glue::glue("test.csv @ {tempdir()}")
  expect_true(any(grepl(expected_msg, log_output)))
})

test_that("connector_fs logging methods handle spaces in paths", {
  skip_if_not_installed("whirl")
  # Create a connector_fs object with path containing spaces
  fs_connector_spaces <- structure(
    list(path = file.path(tempdir(), "path with spaces")),
    class = "connector_fs"
  )

  # Capture the log output
  log_output <- capture.output({
    log_read_connector.connector_fs(fs_connector_spaces, "file with spaces.csv")
  })

  # Verify the correct message was logged
  expected_msg <- glue::glue(
    "file with spaces.csv @ {tempdir()}/path with spaces"
  )
  expect_true(any(grepl(expected_msg, log_output)))
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
  expected_msg_empty_path <- glue::glue("test.csv @ ")
  expect_true(any(grepl(expected_msg_empty_path, log_output_empty_path)))

  # Test with empty name
  log_output_empty_name <- capture.output({
    log_write_connector.connector_fs(fs_connector, "")
  })

  # Verify the correct message was logged
  expected_msg_empty_name <- glue::glue(" @ {tempdir()}")
  expect_true(any(grepl(expected_msg_empty_name, log_output_empty_name)))
})
