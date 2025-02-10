test_that("write_cnt.connector_logger handles success and failure", {
  logger <- connector_logger
  data <- data.frame(x = 1:3)

  # Test success case
  # Create fresh mocks for success case
  next_mock <- mockery::mock() # Empty mock for NextMethod
  log_mock <- mockery::mock() # Empty mock for logging

  mockery::stub(write_cnt.connector_logger, "NextMethod", next_mock)
  mockery::stub(write_cnt.connector_logger, "log_write_connector", log_mock)

  result <- write_cnt.connector_logger(logger, data, "test_file")
  expect_true(is.null(result)) # Should return invisible(TRUE)
  mockery::expect_called(log_mock, 1)

  # Test error case
  # Create fresh mocks for error case
  error_mock <- mockery::mock()
  log_mock <- mockery::mock()

  mockery::stub(
    write_cnt.connector_logger, "NextMethod", function(...) stop("error")
  )
  mockery::stub(write_cnt.connector_logger, "log_write_connector", log_mock)

  expect_error(write_cnt.connector_logger(logger, data, "test_file"), "error")
  mockery::expect_called(log_mock, 0) # Log shouldn't be called on error
})

test_that("read_cnt.connector_logger handles success and failure", {
  logger <- connector_logger

  # Test success case
  next_mock <- mockery::mock()
  log_mock <- mockery::mock()

  mockery::stub(read_cnt.connector_logger, "NextMethod", next_mock)
  mockery::stub(read_cnt.connector_logger, "log_read_connector", log_mock)

  result <- read_cnt.connector_logger(logger, "test_file")
  mockery::expect_called(log_mock, 1)

  # Test error case
  next_mock <- mockery::mock()
  log_mock <- mockery::mock()

  mockery::stub(
    read_cnt.connector_logger, "NextMethod", function(...) stop("error")
  )
  mockery::stub(read_cnt.connector_logger, "log_read_connector", log_mock)

  expect_error(read_cnt.connector_logger(logger, "test_file"), "error")
  mockery::expect_called(log_mock, 0) # Log shouldn't be called on error
})

test_that("remove_cnt.connector_logger handles success and failure", {
  logger <- connector_logger

  # Test success case
  next_mock <- mockery::mock()
  log_mock <- mockery::mock()

  mockery::stub(remove_cnt.connector_logger, "NextMethod", next_mock)
  mockery::stub(remove_cnt.connector_logger, "log_remove_connector", log_mock)

  result <- remove_cnt.connector_logger(logger, "test_file")
  expect_true(is.null(result)) # Should return invisible(TRUE)
  mockery::expect_called(log_mock, 1)

  # Test error case
  next_mock <- mockery::mock()
  log_mock <- mockery::mock()

  mockery::stub(
    remove_cnt.connector_logger, "NextMethod", function(...) stop("error")
  )
  mockery::stub(remove_cnt.connector_logger, "log_remove_connector", log_mock)

  expect_error(remove_cnt.connector_logger(logger, "test_file"), "error")
  mockery::expect_called(log_mock, 0) # Log shouldn't be called on error
})

test_that("list_content_cnt.connector_logger handles success and failure", {
  logger <- connector_logger

  # Test success case
  next_mock <- mockery::mock(c("file1", "file2"))
  log_mock <- mockery::mock()

  mockery::stub(list_content_cnt.connector_logger, "NextMethod", next_mock)
  mockery::stub(
    list_content_cnt.connector_logger, "log_read_connector", log_mock
  )

  result <- list_content_cnt.connector_logger(logger)
  expect_equal(result, c("file1", "file2"))
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, logger, name = ".")

  # Test error case
  next_mock <- mockery::mock()
  log_mock <- mockery::mock()

  mockery::stub(
    list_content_cnt.connector_logger, "NextMethod", function(...) stop("error")
  )
  mockery::stub(
    list_content_cnt.connector_logger, "log_read_connector", log_mock
  )

  expect_error(list_content_cnt.connector_logger(logger), "error")
  mockery::expect_called(log_mock, 0) # Log shouldn't be called on error
})
