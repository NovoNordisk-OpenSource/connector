# Mock whirl functions
whirl <- new.env()
whirl$log_read <- function(name) {}
whirl$log_write <- function(name) {}
whirl$log_delete <- function(name) {}

# Define the log_mock_generator
log_mock_generator <- function() {
  env <- new.env(parent = emptyenv())
  env$call_count <- 0

  function(...) {
    current_count <- env$call_count
    env$call_count <- env$call_count + 1
    current_count
  }
}

test_that("write_cnt.ConnectorLogger handles success and failure", {
  logger <- ConnectorLogger
  data <- data.frame(x = 1:3)

  # Test success case
  log_mock <- log_mock_generator()

  write_cnt.ConnectorLogger <- function(connector_object, x, name, ...) {
    tryCatch(
      {
        # Simulate successful write operation
        log_write_connector(connector_object, name, ...)
        invisible(NULL)
      },
      error = function(e) {
        stop(e)
      }
    )
  }

  with_mocked_bindings(
    {
      result <- write_cnt.ConnectorLogger(logger, data, "test_file")
      expect_null(result)
      expect_equal(log_mock(), 1)
    },
    log_write_connector = log_mock
  )

  # Test error case
  log_mock <- log_mock_generator()

  write_cnt.ConnectorLogger <- function(connector_object, x, name, ...) {
    stop("error")
  }

  with_mocked_bindings(
    {
      expect_error(write_cnt.ConnectorLogger(logger, data, "test_file"), "error")
      expect_equal(log_mock(), 0)
    },
    log_write_connector = log_mock
  )
})

test_that("read_cnt.ConnectorLogger handles success and failure", {
  logger <- ConnectorLogger

  # Test success case
  log_mock <- log_mock_generator()

  read_cnt.ConnectorLogger <- function(connector_object, name, ...) {
    tryCatch(
      {
        res <- "test_data"
        log_read_connector(connector_object, name, ...)
        res
      },
      error = function(e) {
        stop(e)
      }
    )
  }

  with_mocked_bindings(
    {
      result <- read_cnt.ConnectorLogger(logger, "test_file")
      expect_equal(result, "test_data")
      expect_equal(log_mock(), 1)
    },
    log_read_connector = log_mock
  )

  # Test error case
  log_mock <- log_mock_generator()

  read_cnt.ConnectorLogger <- function(connector_object, name, ...) {
    stop("error")
  }

  with_mocked_bindings(
    {
      expect_error(read_cnt.ConnectorLogger(logger, "test_file"), "error")
      expect_equal(log_mock(), 0)
    },
    log_read_connector = log_mock
  )
})

test_that("remove_cnt.ConnectorLogger handles success and failure", {
  logger <- ConnectorLogger

  # Test success case
  log_mock <- log_mock_generator()

  remove_cnt.ConnectorLogger <- function(connector_object, name, ...) {
    tryCatch(
      {
        log_remove_connector(connector_object, name, ...)
        invisible(NULL)
      },
      error = function(e) {
        stop(e)
      }
    )
  }

  with_mocked_bindings(
    {
      result <- remove_cnt.ConnectorLogger(logger, "test_file")
      expect_null(result)
      expect_equal(log_mock(), 1)
    },
    log_remove_connector = log_mock
  )

  # Test error case
  log_mock <- log_mock_generator()

  remove_cnt.ConnectorLogger <- function(connector_object, name, ...) {
    stop("error")
  }

  with_mocked_bindings(
    {
      expect_error(remove_cnt.ConnectorLogger(logger, "test_file"), "error")
      expect_equal(log_mock(), 0)
    },
    log_remove_connector = log_mock
  )
})

test_that("list_content_cnt.ConnectorLogger handles success and failure", {
  logger <- ConnectorLogger

  # Test success case
  log_mock <- log_mock_generator()

  list_content_cnt.ConnectorLogger <- function(connector_object, ...) { # nolint
    tryCatch(
      {
        res <- c("file1", "file2")
        log_read_connector(connector_object, name = ".", ...)
        res
      },
      error = function(e) {
        stop(e)
      }
    )
  }

  with_mocked_bindings(
    {
      result <- list_content_cnt.ConnectorLogger(logger)
      expect_equal(result, c("file1", "file2"))
      expect_equal(log_mock(), 1)
    },
    log_read_connector = log_mock
  )

  # Test error case
  log_mock <- log_mock_generator()

  list_content_cnt.ConnectorLogger <- function(connector_object, ...) { # nolint
    stop("error")
  }

  with_mocked_bindings(
    {
      expect_error(list_content_cnt.ConnectorLogger(logger), "error") # nolint
      expect_equal(log_mock(), 0)
    },
    log_read_connector = log_mock
  )
})

test_that("log_read_connector works correctly", {
  logger <- ConnectorLogger

  # Test default method
  log_read_connector(logger, "test_file") |> 
    expect_output() |> 
    expect_invisible()

  # Test custom method
  log_read_connector.custom <- function(connector_object, name, ...) {
    paste("Custom read:", name)
  }
  class(logger) <- c("custom", class(logger))
  expect_equal(log_read_connector(logger, "test_file"), "Custom read: test_file")
})

test_that("log_write_connector works correctly", {
  logger <- ConnectorLogger

  # Test default method
  log_write_connector(logger, "test_file") |> 
    expect_output() |> 
    expect_invisible()

  # Test custom method
  log_write_connector.custom <- function(connector_object, name, ...) {
    paste("Custom write:", name)
  }
  class(logger) <- c("custom", class(logger))
  expect_equal(log_write_connector(logger, "test_file"), "Custom write: test_file")
})

test_that("log_remove_connector works correctly", {
  logger <- ConnectorLogger

  # Test default method
  log_remove_connector(logger, "test_file") |> 
    expect_output() |> 
    expect_invisible()

  # Test custom method
  log_remove_connector.custom <- function(connector_object, name, ...) {
    paste("Custom remove:", name)
  }
  class(logger) <- c("custom", class(logger))
  expect_equal(log_remove_connector(logger, "test_file"), "Custom remove: test_file")
})

test_that("print.ConnectorLogger works correctly", {
  logger <- ConnectorLogger

  # Capture the output of print
  output <- capture.output(print(logger))

  # Check that the output is as expected
  expect_true(any(grepl("ConnectorLogger", output)))
})


# Additional tests

# Test ConnectorLogger creation
test_that("ConnectorLogger is created correctly", {
  logger <- ConnectorLogger
  expect_s3_class(logger, "ConnectorLogger")
  expect_equal(length(logger), 0)
})

# Test generic functions
test_that("generic functions call the correct method", {
  logger <- ConnectorLogger
  mock_method <- function(...) "mock called"

  # Use local_mocked_bindings for the generic functions
  local_mocked_bindings(
    log_read_connector = function(...) mock_method(...),
    log_write_connector = function(...) mock_method(...),
    log_remove_connector = function(...) mock_method(...),
    log_list_content_connector = function(...) mock_method(...)
  )

  expect_equal(log_read_connector(logger, "test"), "mock called")
  expect_equal(log_write_connector(logger, "test"), "mock called")
  expect_equal(log_remove_connector(logger, "test"), "mock called")
  expect_equal(log_list_content_connector(logger), "mock called")
})

# Test default methods
test_that("default methods call correct whirl functions", {
  logger <- list()

  # Mock whirl functions
  local_mocked_bindings(
    log_read = function(...) "read called",
    log_write = function(...) "write called",
    log_delete = function(...) "delete called",
    .package = "whirl"
  )

  expect_equal(log_read_connector(logger, "test"), "read called")
  expect_equal(log_write_connector(logger, "test"), "write called")
  expect_equal(log_remove_connector(logger, "test"), "delete called")
})

# Test list_content_cnt.ConnectorLogger
test_that("list_content_cnt.ConnectorLogger works correctly", {
  logger <- ConnectorLogger

  # Create a mock NextMethod function
  mock_next_method <- function(...) c("file1", "file2")

  # Temporarily replace the NextMethod function
  original_next_method <- base::NextMethod
  base::unlockBinding("NextMethod", as.environment("package:base"))
  base::assign("NextMethod", mock_next_method, as.environment("package:base"))

  # Use local_mocked_bindings for log_read_connector
  local_mocked_bindings(
    log_read_connector = function(...) NULL
  )

  # Run the test
  tryCatch({
    result <- list_content_cnt.ConnectorLogger(logger)
    expect_equal(result, c("file1", "file2"))
  }, finally = {
    # Restore the original NextMethod function
    base::assign("NextMethod", original_next_method, as.environment("package:base"))
    base::lockBinding("NextMethod", as.environment("package:base"))
  })
})

# Test print.ConnectorLogger
test_that("print.ConnectorLogger works correctly", {
  logger <- ConnectorLogger

  output <- capture.output(print(logger))
  expect_true(any(grepl("ConnectorLogger", output)))
})
