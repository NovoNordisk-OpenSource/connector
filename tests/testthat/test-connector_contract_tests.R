# These tests run a small made-up suite, so they check how any suite is built
# and run, not what the default contract cases contain.

empty_suite <- function() connector_contract_tests(cases = list())

fake_suite <- function() {
  connector_contract_tests(
    cases = list(
      method_a = list(
        "passes" = function(cnt) expect_true(TRUE),
        "fails" = function(cnt) expect_true(FALSE)
      ),
      method_b = list(
        "passes" = function(cnt) expect_true(TRUE)
      )
    )
  )
}

# Run a suite under its own reporter so its failures don't fail this test
run_quietly <- function(suite, new_connector = \(env) NULL) {
  reporter <- testthat::ListReporter$new()
  suite$run(new_connector, reporter = reporter)
  as.data.frame(reporter$get_results())
}

# Names of the tests a suite runs, without the common prefix
cases_run <- function(suite) {
  sub("^connector contract: ", "", run_quietly(suite)$test)
}

test_that("connector_contract_cases() has cases for every connector method", {
  # Act
  cases <- connector_contract_cases()

  # Assert
  expect_named(
    cases,
    c(
      "write_cnt",
      "read_cnt",
      "list_content_cnt",
      "remove_cnt",
      "create_directory_cnt",
      "remove_directory_cnt",
      "download_cnt",
      "upload_cnt"
    )
  )
})

test_that("connector_contract_tests() starts with the given cases", {
  # Arrange
  suite <- fake_suite()

  # Act
  result <- cases_run(suite)

  # Assert
  expect_equal(
    result,
    c("method_a() passes", "method_a() fails", "method_b() passes")
  )
})

test_that("connector_contract_tests() rejects cases not grouped by method", {
  # Arrange
  cases <- list("a case" = function(cnt) NULL)

  # Act and Assert
  expect_error(
    connector_contract_tests(cases = cases),
    regexp = "cases"
  )
})

test_that("add_case() adds a case and returns the suite", {
  # Arrange
  suite <- empty_suite()

  # Act
  returned <- suite$add_case("method", "a case", function(cnt) NULL)

  # Assert
  expect_identical(returned, suite)
  expect_equal(cases_run(suite), "method() a case")
})

test_that("add_case() rejects a case name already in its method", {
  # Arrange
  suite <- fake_suite()

  # Act and Assert
  expect_error(
    suite$add_case("method_a", "passes", function(cnt) NULL),
    regexp = "already in"
  )
})

test_that("add_case() allows a case name used by another method", {
  # Arrange
  suite <- fake_suite()

  # Act
  suite$add_case("method_c", "passes", function(cnt) expect_true(TRUE))

  # Assert
  expect_equal(
    cases_run(suite),
    c(
      "method_a() passes",
      "method_a() fails",
      "method_b() passes",
      "method_c() passes"
    )
  )
})

test_that("add_case() rejects a case that is not a function of cnt", {
  # Arrange
  suite <- empty_suite()

  # Act and Assert
  expect_error(suite$add_case("method", "a case", "not a function"))
  expect_error(suite$add_case("method", "a case", function(x) NULL))
})

test_that("remove_case() removes one case and returns the suite", {
  # Arrange
  suite <- fake_suite()

  # Act
  returned <- suite$remove_case("method_a", "fails")

  # Assert
  expect_identical(returned, suite)
  expect_equal(cases_run(suite), c("method_a() passes", "method_b() passes"))
})

test_that("remove_case() errors on a case or method not in the suite", {
  # Arrange
  suite <- fake_suite()

  # Act and Assert
  expect_error(
    suite$remove_case("method_a", "no such case"),
    regexp = "no such case"
  )
  expect_error(
    suite$remove_case("no_such_cnt", "passes"),
    regexp = "no_such_cnt"
  )
})

test_that("remove_method() removes all of a method's cases", {
  # Arrange
  suite <- fake_suite()

  # Act
  returned <- suite$remove_method("method_a")

  # Assert
  expect_identical(returned, suite)
  expect_equal(cases_run(suite), "method_b() passes")
})

test_that("remove_method() errors on a method not in the suite", {
  # Arrange
  suite <- fake_suite()

  # Act and Assert
  expect_error(suite$remove_method("no_such_cnt"), regexp = "no_such_cnt")
})

test_that("builder methods chain", {
  # Act
  suite <- fake_suite()$remove_method("method_b")$remove_case(
    "method_a",
    "fails"
  )$add_case("method_c", "passes", function(cnt) NULL)

  # Assert
  expect_equal(cases_run(suite), c("method_a() passes", "method_c() passes"))
})

test_that("clone() gives a copy that changes independently", {
  # Arrange
  suite <- fake_suite()

  # Act
  copy <- suite$clone()$remove_method("method_a")

  # Assert
  expect_equal(
    cases_run(suite),
    c("method_a() passes", "method_a() fails", "method_b() passes")
  )
  expect_equal(cases_run(copy), "method_b() passes")
})

test_that("print() lists cases grouped by method", {
  # Arrange
  suite <- fake_suite()

  # Act and Assert
  expect_snapshot(print(suite))
})

test_that("print() drops a method once its last case is removed", {
  # Arrange
  suite <- fake_suite()

  # Act
  suite$remove_case("method_b", "passes")

  # Assert
  expect_snapshot(print(suite))
})

test_that("run() runs each case as its own test", {
  # Act
  result <- run_quietly(fake_suite())

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

test_that("run() gives each case a new connector", {
  # Arrange
  received <- c()
  suite <- empty_suite()$add_case(
    "method",
    "first case",
    function(cnt) received <<- c(received, cnt)
  )$add_case(
    "method",
    "second case",
    function(cnt) received <<- c(received, cnt)
  )
  created <- 0

  # Act
  run_quietly(suite, new_connector = \(env) created <<- created + 1)

  # Assert
  expect_equal(received, c(1, 2))
})

test_that("run() cleans up after each case", {
  # Arrange
  events <- c()
  log_event <- function(event) events <<- c(events, event)
  suite <- empty_suite()$add_case(
    "method",
    "first case",
    function(cnt) log_event("run first")
  )$add_case(
    "method",
    "second case",
    function(cnt) log_event("run second")
  )

  # Act
  run_quietly(
    suite,
    new_connector = \(env) withr::defer(log_event("clean up"), envir = env)
  )

  # Assert
  expect_equal(
    events,
    c("run first", "clean up", "run second", "clean up")
  )
})

test_that("run() rejects new_connector without an env argument", {
  # Arrange
  suite <- fake_suite()

  # Act and Assert
  expect_error(suite$run(new_connector = \() NULL), regexp = "env")
})

test_that("run() rejects a reporter that is not one", {
  # Arrange
  suite <- fake_suite()

  # Act and Assert
  expect_error(
    suite$run(new_connector = \(env) NULL, reporter = "progress"),
    regexp = "reporter"
  )
})

test_that("run() reports to its own reporter outside a testthat run", {
  # Arrange
  withr::local_envvar(TESTTHAT = "false")
  suite <- fake_suite()

  # Act and Assert
  expect_output(
    suite$run(new_connector = \(env) NULL),
    "[ FAIL 1 | WARN 0 | SKIP 0 | PASS 2 ]",
    fixed = TRUE
  )
})

test_that("get_case() returns the case function", {
  # Arrange
  case <- function(cnt) NULL
  suite <- empty_suite()$add_case("method", "a case", case)

  # Act and Assert
  expect_identical(suite$get_case("method", "a case"), case)
})
