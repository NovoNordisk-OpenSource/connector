# These tests run a small made-up suite, so they check how any suite is run,
# not what the exported contract tests contain.

fake_tests <- function() {
  list(
    method_a = list(
      "method_a() passes" = function(cnt) expect_true(TRUE),
      "method_a() fails" = function(cnt) expect_true(FALSE)
    ),
    method_b = list(
      "method_b() passes" = function(cnt) expect_true(TRUE)
    )
  )
}

test_that("run_connector_contract_tests() returns one result per case", {
  # Act
  result <- run_connector_contract_tests(
    fake_tests(),
    new_connector = \(env) "connector",
    reporter = testthat::SilentReporter$new()
  )

  # Assert
  expect_equal(
    result$test,
    paste(
      "connector contract:",
      c("method_a() passes", "method_a() fails", "method_b() passes")
    )
  )
  expect_equal(result$failed, c(0, 1, 0))
})

test_that("run_connector_contract_tests() gives each case a new connector", {
  # Arrange
  received <- c()
  tests <- list(
    method = list(
      "first case" = function(cnt) received <<- c(received, cnt),
      "second case" = function(cnt) received <<- c(received, cnt)
    )
  )
  created <- 0

  # Act
  run_connector_contract_tests(
    tests,
    new_connector = \(env) created <<- created + 1,
    reporter = testthat::SilentReporter$new()
  )

  # Assert
  expect_equal(received, c(1, 2))
})

test_that("run_connector_contract_tests() cleans up after each case", {
  # Arrange
  events <- c()
  log_event <- function(event) events <<- c(events, event)
  tests <- list(
    method = list(
      "first case" = function(cnt) log_event("run first"),
      "second case" = function(cnt) log_event("run second")
    )
  )

  # Act
  run_connector_contract_tests(
    tests,
    new_connector = \(env) withr::defer(log_event("clean up"), envir = env),
    reporter = testthat::SilentReporter$new()
  )

  # Assert
  expect_equal(
    events,
    c("run first", "clean up", "run second", "clean up")
  )
})

test_that("run_connector_contract_tests() rejects a non-function case", {
  # Arrange
  tests <- fake_tests()
  tests[["method_b"]][["method_b() passes"]] <- "not a function"

  # Act and Assert
  expect_error(
    run_connector_contract_tests(tests, new_connector = \(env) NULL),
    regexp = paste(
      r"(Assertion on 'tests[["method_b"]]' failed:)",
      "May only contain the following types: {function},",
      "but element 1 has type 'character'."
    ),
    fixed = TRUE
  )
})

test_that("run_connector_contract_tests() rejects duplicated case names", {
  # Arrange
  tests <- fake_tests()
  tests[["method_b"]][["method_a() passes"]] <- function(cnt) NULL

  # Act and Assert
  expect_error(
    run_connector_contract_tests(tests, new_connector = \(env) NULL),
    regexp = paste0(
      r"(Case names must be unique\.\n)",
      r"(.*Duplicated: "method_a\(\) passes")"
    )
  )
})

test_that("run_connector_contract_tests() rejects a reporter that is not one", {
  # Act and Assert
  expect_error(
    run_connector_contract_tests(
      fake_tests(),
      new_connector = \(env) NULL,
      reporter = "progress"
    ),
    regexp = paste(
      "Assertion on 'reporter' failed:",
      "Must be an R6 class (or 'NULL'), not character."
    ),
    fixed = TRUE
  )
})
