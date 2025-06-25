# Helper function to create a test ConnectorDBI object
create_test_ConnectorDBI <- function() {
  conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  structure(
    list(conn = conn),
    class = c("ConnectorDBI", "connector")
  )
}

test_that("log_read_connector.ConnectorDBI logs correct message", {
  skip_if_not_installed("whirl")

  connector_object <- create_test_ConnectorDBI()

  # Capture the log output
  log_output <- capture.output({
    log_read_connector.ConnectorDBI(connector_object, "test_table")
  })

  # Verify the correct message was logged
  expected_msg <- "test_table @ driver: SQLiteConnection, dbname: :memory:"
  expect_true(any(grepl(expected_msg, log_output, fixed = TRUE)))

  DBI::dbDisconnect(connector_object$conn)
})

test_that("log_write_connector.ConnectorDBI logs correct message", {
  skip_if_not_installed("whirl")

  connector_object <- create_test_ConnectorDBI()

  # Capture the log output
  log_output <- capture.output({
    log_write_connector.ConnectorDBI(connector_object, "test_table")
  })

  # Verify the correct message was logged
  expected_msg <- "test_table @ driver: SQLiteConnection, dbname: :memory:"
  expect_true(any(grepl(expected_msg, log_output, fixed = TRUE)))

  DBI::dbDisconnect(connector_object$conn)
})

test_that("log_remove_connector.ConnectorDBI logs correct message", {
  skip_if_not_installed("whirl")

  connector_object <- create_test_ConnectorDBI()

  # Capture the log output
  log_output <- capture.output({
    log_remove_connector.ConnectorDBI(connector_object, "test_table")
  })

  # Verify the correct message was logged
  expected_msg <- "test_table @ driver: SQLiteConnection, dbname: :memory:"
  expect_true(any(grepl(expected_msg, log_output, fixed = TRUE)))

  DBI::dbDisconnect(connector_object$conn)
})

test_that("ConnectorDBI logging methods handle special characters in names", {
  skip_if_not_installed("whirl")

  connector_object <- create_test_ConnectorDBI()

  # Test with a table name containing special characters
  special_name <- "test-table; DROP TABLE students;--"

  # Capture the log output
  log_output <- capture.output({
    log_read_connector.ConnectorDBI(connector_object, special_name)
  })

  # Verify the correct message was logged
  expected_msg <- paste0(
    special_name,
    " @ driver: SQLiteConnection, dbname: :memory:"
  )
  expect_true(any(grepl(expected_msg, log_output, fixed = TRUE)))

  DBI::dbDisconnect(connector_object$conn)
})
