#' Connector contract tests
#'
#' A shared set of `testthat` tests for the behaviour every connector backend
#' should share, as described in `vignette("Consistent-API")`: what each
#' method returns, that data read back equals data written, and that listing
#' reflects writes and removals.
#'
#' `connector_contract_tests()` builds the tests as a plan: a named list with
#' one entry per connector method, each a named list of cases for that method.
#' A case is a `function(cnt)` that runs expectations against a new, empty
#' connector. `lapply(tests, names)` shows what will run. Change it with
#' ordinary list operations before running it:
#'
#' * drop a method the backend does not support:
#'   `tests[["create_directory_cnt"]] <- NULL`
#' * drop a case:
#'   `tests[["read_cnt"]][["read_cnt() errors on missing content"]] <- NULL`
#' * replace or add a case:
#'   `tests[["read_cnt"]][["<case>"]] <- function(cnt) ...`
#'
#' Case names are sentences describing the expected behaviour, and are unique
#' across methods. `run_connector_contract_tests()` runs every case as its own
#' [testthat::test_that()], named `"connector contract: <case>"`.
#' Call it from a test file in a package that extends connector.
#'
#' @section Debugging a failing case:
#' Failures name the case and say what was expected, but point at the line that
#' calls `run_connector_contract_tests()`, not at the case itself. A case is a
#' plain function, so you can print its code and step through it:
#'
#' ```r
#' tests <- connector_contract_tests()
#' case <- tests[["remove_cnt"]][[
#'   "remove_cnt() returns the connector and removes content"
#' ]]
#' case                                     # prints the case's code
#' cnt <- new_connector(env = globalenv())  # your connector function
#' debugonce(case)
#' case(cnt)
#' ```
#'
#' To rerun only one method's cases outside a test run, and get their results
#' as a `data.frame`:
#'
#' ```r
#' run_connector_contract_tests(tests["remove_cnt"], new_connector)
#' ```
#'
#' @param name Name used to write the test data. Its extension, if any, decides
#'   the file format. The default `.rds` reads back exactly what was written.
#' @param data Any R object the backend can write under `name` with
#'   `write_cnt()`.
#' @param expect_read_back A `testthat` expectation,
#'   `function(object, expected)`, used by the [read_cnt()] read-back case.
#'   `object` is what [read_cnt()] returned and `expected` is `data`. It must
#'   call `testthat::expect_*()` functions. The default expects them to be
#'   equal, which suits formats that keep the object as written, such as
#'   `.rds`. Pass your own for backends that don't, e.g. a database that
#'   returns rows in any order.
#' @return A named list of named lists of functions.
#' @examples
#' tests <- connector_contract_tests()
#' lapply(tests, names)
#'
#' \dontrun{
#' # tests/testthat/test-contract.R
#' tests <- connector_contract_tests()
#' tests[["download_cnt"]] <- NULL
#' tests[["upload_cnt"]] <- NULL
#'
#' run_connector_contract_tests(
#'   tests,
#'   new_connector = \(env) {
#'     connector_fs(withr::local_tempdir(.local_envir = env))
#'   }
#' )
#' }
#' @export
connector_contract_tests <- function(
  name = "contract.rds",
  data = data.frame(x = c(1, 2, 3), y = c("a", "b", "c")),
  expect_read_back = function(object, expected) {
    testthat::expect_equal(
      object,
      expected,
      label = "read_cnt(cnt, name) return value",
      expected.label = "the written data"
    )
  }
) {
  checkmate::assert_string(name)
  checkmate::assert_function(expect_read_back, args = c("object", "expected"))

  tests <- list(
    write_cnt = list(
      "write_cnt() returns the connector" = function(cnt) {
        # Act
        returned <- write_cnt(cnt, data, name)

        # Assert
        testthat::expect_identical(
          returned,
          cnt,
          label = "write_cnt(cnt, data, name) return value",
          expected.label = "the connector"
        )
      }
    ),
    read_cnt = list(
      "read_cnt() returns the written data" = function(cnt) {
        # Arrange
        write_cnt(cnt, data, name)

        # Act
        read_data <- read_cnt(cnt, name)

        # Assert
        expect_read_back(object = read_data, expected = data)
      },
      "read_cnt() errors on missing content" = function(cnt) {
        # Arrange
        missing_name <- paste0("missing_", name)

        # Act and Assert
        testthat::expect_error(
          read_cnt(cnt, missing_name),
          info = paste0("\"", missing_name, "\" was never written")
        )
      }
    ),
    list_content_cnt = list(
      "list_content_cnt() lists written content" = function(cnt) {
        # Arrange
        write_cnt(cnt, data, name)

        # Act
        listed_content <- list_content_cnt(cnt)

        # Assert
        testthat::expect_type(listed_content, "character")
        testthat::expect_contains(listed_content, name)
      }
    ),
    remove_cnt = list(
      "remove_cnt() returns the connector and removes content" = function(cnt) {
        # Arrange
        write_cnt(cnt, data, name)

        # Act
        returned <- remove_cnt(cnt, name)

        # Assert
        testthat::expect_identical(
          returned,
          cnt,
          label = "remove_cnt(cnt, name) return value",
          expected.label = "the connector"
        )
        testthat::expect_false(
          name %in% list_content_cnt(cnt),
          info = paste0("remove_cnt() should remove \"", name, "\"")
        )
      }
    ),
    create_directory_cnt = list(
      "create_directory_cnt(open = FALSE) returns the connector" =
        function(cnt) {
          # Act
          returned <- create_directory_cnt(cnt, "contract_dir", open = FALSE)

          # Assert
          testthat::expect_identical(
            returned,
            cnt,
            label = "create_directory_cnt(open = FALSE) return value",
            expected.label = "the connector"
          )
          testthat::expect_contains(list_content_cnt(cnt), "contract_dir")
        },
      "create_directory_cnt(open = TRUE) returns a new connector" =
        function(cnt) {
          # Act
          opened_connector <- create_directory_cnt(
            cnt,
            "contract_dir",
            open = TRUE
          )

          # Assert
          testthat::expect_s3_class(opened_connector, class(cnt)[[1]])
          testthat::expect_false(
            identical(opened_connector, cnt),
            info = "open = TRUE should return a connector to the new directory"
          )
        }
    ),
    remove_directory_cnt = list(
      "remove_directory_cnt() returns the connector and removes it" =
        function(cnt) {
          # Arrange
          create_directory_cnt(cnt, "contract_dir", open = FALSE)

          # Act
          returned <- remove_directory_cnt(cnt, "contract_dir")

          # Assert
          testthat::expect_identical(
            returned,
            cnt,
            label = "remove_directory_cnt(cnt, \"contract_dir\") return value",
            expected.label = "the connector"
          )
          testthat::expect_false(
            "contract_dir" %in% list_content_cnt(cnt),
            info = "remove_directory_cnt() should remove \"contract_dir\""
          )
        }
    ),
    download_cnt = list(
      "download_cnt() returns the connector and creates a file" =
        function(cnt) {
          # Arrange
          write_cnt(cnt, data, name)
          # ponytail: plain tempfile, left in session tempdir if test fails
          dest <- tempfile(fileext = paste0(".", tools::file_ext(name)))

          # Act
          returned <- download_cnt(cnt, src = name, dest = dest)

          # Assert
          testthat::expect_identical(
            returned,
            cnt,
            label = "download_cnt(cnt, src = name, dest = dest) return value",
            expected.label = "the connector"
          )
          testthat::expect_true(
            file.exists(dest),
            info = paste0("download_cnt() should create \"", dest, "\"")
          )
          unlink(dest)
        }
    ),
    upload_cnt = list(
      "upload_cnt() returns the connector and adds content" = function(cnt) {
        # Arrange
        src <- tempfile(fileext = paste0(".", tools::file_ext(name)))
        write_file(data, src)
        dest <- paste0("uploaded_", name)

        # Act
        returned <- upload_cnt(cnt, src = src, dest = dest)

        # Assert
        testthat::expect_identical(
          returned,
          cnt,
          label = "upload_cnt(cnt, src = src, dest = dest) return value",
          expected.label = "the connector"
        )
        testthat::expect_contains(list_content_cnt(cnt), dest)
        unlink(src)
      }
    )
  )
  tests
}

#' @param tests A plan from `connector_contract_tests()`, or any list of the
#'   same shape.
#' @param new_connector `function(env)` returning a new, empty connector. Any
#'   cleanup must be tied to `env`, e.g. with
#'   `withr::local_tempdir(.local_envir = env)`, so it runs when each test ends.
#' @param reporter `NULL` to report to the active `testthat` reporter, as in a
#'   package's test files. Or a [testthat::Reporter], e.g.
#'   `testthat::SilentReporter$new()`, to run the cases on their own and return
#'   their results. Defaults to `NULL` inside a `testthat` run and to a
#'   progress reporter outside one.
#' @return `run_connector_contract_tests()`: with `reporter = NULL`, `tests`
#'   invisibly. With a reporter, a `data.frame`, invisibly, with one row per
#'   case: `test`, `nb` (expectations), `failed`, `skipped` and `error`.
#' @rdname connector_contract_tests
#' @export
run_connector_contract_tests <- function(
  tests,
  new_connector,
  reporter = if (testthat::is_testing()) {
    NULL
  } else {
    testthat::ProgressReporter$new(show_praise = FALSE)
  }
) {
  rlang::check_installed("testthat")
  check_contract_tests(tests)
  checkmate::assert_function(new_connector, args = "env")
  checkmate::assert_r6(reporter, "Reporter", null.ok = TRUE)

  run_cases <- function() {
    for (method in names(tests)) {
      for (case in names(tests[[method]])) {
        test_case <- tests[[method]][[case]]
        testthat::test_that(paste("connector contract:", case), {
          # Create the connector here, not as a lazy argument, so it exists
          # and is cleaned up even when a case never uses it
          cnt <- new_connector(env = environment())
          test_case(cnt)
        })
      }
    }
  }

  # Report to the active reporter so results show up alongside the package's
  # other tests
  if (is.null(reporter)) {
    run_cases()
    return(invisible(tests))
  }

  list_reporter <- testthat::ListReporter$new()
  reporters <- testthat::MultiReporter$new(list(reporter, list_reporter))
  testthat::with_reporter(reporters, {
    list_reporter$start_file("connector contract")
    run_cases()
    list_reporter$end_file()
  })

  invisible(as.data.frame(list_reporter$get_results())[
    c("test", "nb", "failed", "skipped", "error")
  ])
}

#' Check that contract tests are a named list of named lists of functions,
#' with case names unique across methods
#' @noRd
check_contract_tests <- function(tests) {
  checkmate::assert_list(tests, types = "list", names = "unique")
  for (method in names(tests)) {
    checkmate::assert_list(
      tests[[method]],
      types = "function",
      names = "unique",
      .var.name = paste0("tests[[\"", method, "\"]]")
    )
  }
  cases <- unlist(lapply(tests, names), use.names = FALSE)
  if (anyDuplicated(cases)) {
    cli::cli_abort(c(
      "Case names must be unique.",
      "x" = "Duplicated: {.val {unique(cases[duplicated(cases)])}}"
    ))
  }
}
