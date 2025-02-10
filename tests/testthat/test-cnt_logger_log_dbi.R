test_that("log_read_connector.connector_dbi logs correct message", {
  skip_if_not_installed("whirl")
  # Create a mock connector_dbi object
  connector_object <- connector::connector_dbi$new(
    RSQLite::SQLite(),
    extra_class = "connector_logger"
  )

  # Create mock for whirl::log_read
  log_mock <- mockery::mock()
  mockery::stub(log_read_connector.connector_dbi, "whirl::log_read", log_mock)

  # Test the function
  log_read_connector.connector_dbi(connector_object, "test_connector")

  # Verify log_read was called with correct message
  expected_msg <- "test_connector @ driver: SQLiteConnection, dbname: "
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

test_that("log_write_connector.connector_dbi logs correct message", {
  skip_if_not_installed("whirl")
  # Create a mock connector_dbi object
  connector_object <- connector::connector_dbi$new(
    RSQLite::SQLite(),
    extra_class = "connector_logger"
  )

  # Create mock for whirl::log_write
  log_mock <- mockery::mock()
  mockery::stub(log_write_connector.connector_dbi, "whirl::log_write", log_mock)

  # Test the function
  log_write_connector.connector_dbi(connector_object, "test_connector")

  # Verify log_write was called with correct message
  expected_msg <- "test_connector @ driver: SQLiteConnection, dbname: "
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

test_that("log_remove_connector.connector_dbi logs correct message", {
  skip_if_not_installed("whirl")
  # Create a mock connector_dbi object
  connector_object <- connector::connector_dbi$new(
    RSQLite::SQLite(),
    extra_class = "connector_logger"
  )

  # Create mock for whirl::log_delete
  log_mock <- mockery::mock()
  mockery::stub(
    log_remove_connector.connector_dbi,
    "whirl::log_delete",
    log_mock
  )

  # Test the function
  log_remove_connector.connector_dbi(connector_object, "test_connector")

  # Verify log_delete was called with correct message
  expected_msg <- "test_connector @ driver: SQLiteConnection, dbname: "
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})
