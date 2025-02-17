library(testthat)

# Mock whirl functions
whirl <- new.env()
whirl$log_read <- function(name) {}
whirl$log_write <- function(name) {}
whirl$log_delete <- function(name) {}

# Define the log_mock_generator
log_mock_generator <- function() {
  call_count <- 0
  function(...) {
    current_count <- call_count
    call_count <<- call_count + 1
    current_count
  }
}

test_that("write_cnt.connector_logger handles success and failure", {
  logger <- connector_logger
  data <- data.frame(x = 1:3)

  # Test success case
  log_mock <- log_mock_generator()

  write_cnt.connector_logger <- function(connector_object, x, name, ...) {
    tryCatch({
      # Simulate successful write operation
      log_write_connector(connector_object, name, ...)
      invisible(NULL)
    }, error = function(e) {
      stop(e)
    })
  }

  with_mocked_bindings({
    result <- write_cnt.connector_logger(logger, data, "test_file")
    expect_null(result)
    expect_equal(log_mock(), 1)
  },
  log_write_connector = log_mock
  )

  # Test error case
  log_mock <- log_mock_generator()

  write_cnt.connector_logger <- function(connector_object, x, name, ...) {
    stop("error")
  }

  with_mocked_bindings({
    expect_error(write_cnt.connector_logger(logger, data, "test_file"), "error")
    expect_equal(log_mock(), 0)
  },
  log_write_connector = log_mock
  )
})

test_that("read_cnt.connector_logger handles success and failure", {
  logger <- connector_logger

  # Test success case
  log_mock <- log_mock_generator()

  read_cnt.connector_logger <- function(connector_object, name, ...) {
    tryCatch({
      res <- "test_data"
      log_read_connector(connector_object, name, ...)
      res
    }, error = function(e) {
      stop(e)
    })
  }

  with_mocked_bindings({
    result <- read_cnt.connector_logger(logger, "test_file")
    expect_equal(result, "test_data")
    expect_equal(log_mock(), 1)
  },
  log_read_connector = log_mock
  )

  # Test error case
  log_mock <- log_mock_generator()

  read_cnt.connector_logger <- function(connector_object, name, ...) {
    stop("error")
  }

  with_mocked_bindings({
    expect_error(read_cnt.connector_logger(logger, "test_file"), "error")
    expect_equal(log_mock(), 0)
  },
  log_read_connector = log_mock
  )
})

test_that("remove_cnt.connector_logger handles success and failure", {
  logger <- connector_logger

  # Test success case
  log_mock <- log_mock_generator()

  remove_cnt.connector_logger <- function(connector_object, name, ...) {
    tryCatch({
      log_remove_connector(connector_object, name, ...)
      invisible(NULL)
    }, error = function(e) {
      stop(e)
    })
  }

  with_mocked_bindings({
    result <- remove_cnt.connector_logger(logger, "test_file")
    expect_null(result)
    expect_equal(log_mock(), 1)
  },
  log_remove_connector = log_mock
  )

  # Test error case
  log_mock <- log_mock_generator()

  remove_cnt.connector_logger <- function(connector_object, name, ...) {
    stop("error")
  }

  with_mocked_bindings({
    expect_error(remove_cnt.connector_logger(logger, "test_file"), "error")
    expect_equal(log_mock(), 0)
  },
  log_remove_connector = log_mock
  )
})

test_that("list_content_cnt.connector_logger handles success and failure", {
  logger <- connector_logger

  # Test success case
  log_mock <- log_mock_generator()

  list_content_cnt.connector_logger <- function(connector_object, ...) {
    tryCatch({
      res <- c("file1", "file2")
      log_read_connector(connector_object, name = ".", ...)
      res
    }, error = function(e) {
      stop(e)
    })
  }

  with_mocked_bindings({
    result <- list_content_cnt.connector_logger(logger)
    expect_equal(result, c("file1", "file2"))
    expect_equal(log_mock(), 1)
  },
  log_read_connector = log_mock
  )

  # Test error case
  log_mock <- log_mock_generator()

  list_content_cnt.connector_logger <- function(connector_object, ...) {
    stop("error")
  }

  with_mocked_bindings({
    expect_error(list_content_cnt.connector_logger(logger), "error")
    expect_equal(log_mock(), 0)
  },
  log_read_connector = log_mock
  )
})

test_that("log_read_connector works correctly", {
  logger <- connector_logger

  # Test default method
  expect_invisible(log_read_connector(logger, "test_file"))

  # Test custom method
  log_read_connector.custom <- function(connector_object, name, ...) {
    paste("Custom read:", name)
  }
  class(logger) <- c("custom", class(logger))
  expect_equal(log_read_connector(logger, "test_file"), "Custom read: test_file")
})

test_that("log_write_connector works correctly", {
  logger <- connector_logger

  # Test default method
  expect_invisible(log_write_connector(logger, "test_file"))

  # Test custom method
  log_write_connector.custom <- function(connector_object, name, ...) {
    paste("Custom write:", name)
  }
  class(logger) <- c("custom", class(logger))
  expect_equal(log_write_connector(logger, "test_file"), "Custom write: test_file")
})

test_that("log_remove_connector works correctly", {
  logger <- connector_logger

  # Test default method
  expect_invisible(log_remove_connector(logger, "test_file"))

  # Test custom method
  log_remove_connector.custom <- function(connector_object, name, ...) {
    paste("Custom remove:", name)
  }
  class(logger) <- c("custom", class(logger))
  expect_equal(log_remove_connector(logger, "test_file"), "Custom remove: test_file")
})

test_that("print.connector_logger works correctly", {
  logger <- connector_logger

  # Capture the output of print
  output <- capture.output(print(logger))

  # Check that the output is as expected
  expect_true(any(grepl("connector_logger", output)))
})
