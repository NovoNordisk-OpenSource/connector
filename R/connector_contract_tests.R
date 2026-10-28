#' Connector contract tests
#'
#' A shared set of `testthat` tests for the behaviour every connector backend
#' should share, as described in `vignette("Consistent-API")`: what each
#' method returns, that data read back equals data written, and that listing
#' reflects writes and removals.
#'
#' `connector_contract_tests()` returns a [ConnectorContract] suite, by default
#' with the cases from `connector_contract_cases()`: a named list with one
#' entry per connector method, each a named list of cases. A case is a
#' `function(cnt)` that runs expectations against a new, empty connector.
#' Print the suite to see what will run, and change it before running it:
#'
#' * drop a method the backend does not support:
#'   `suite$remove_method("create_directory_cnt")`
#' * drop a case:
#'   `suite$remove_case("read_cnt", "errors on missing content")`
#' * add a case: `suite$add_case("read_cnt", "<case>", function(cnt) ...)`
#'
#' The builder methods change the suite in place and return it, so they chain.
#' Use `suite$clone()` to change a copy instead.
#'
#' Case names describe the expected behaviour of their method, and are unique
#' within it. The same name can describe several methods, e.g.
#' `"returns the connector"`. `suite$run()` runs every case as its own
#' [testthat::test_that()], named `"connector contract: <method>() <case>"`.
#' Call it from a test file in a package that extends connector.
#'
#' @section Debugging a failing case:
#' Failures name the case and say what was expected, but point at the line that
#' calls `suite$run()`, not at the case itself. A case is a plain function, so
#' you can print its code and step through it:
#'
#' ```r
#' case <- connector_contract_tests()$get_case(
#'   "remove_cnt",
#'   "returns the connector and removes content"
#' )
#' case                                     # prints the case's code
#' cnt <- new_connector(env = globalenv())  # your connector function
#' debugonce(case)
#' case(cnt)
#' ```
#'
#' @param cases Cases to start the suite with, as a named list of named lists
#'   of `function(cnt)`, grouped by method. Pass
#'   `connector_contract_cases(...)` to change the default test data, or
#'   `list()` to start empty.
#' @return `connector_contract_tests()`: a [ConnectorContract] object.
#' @examples
#' connector_contract_tests()
#'
#' # tests/testthat/test-contract.R
#' connector_contract_tests()$
#'   remove_method("download_cnt")$
#'   remove_method("upload_cnt")$
#'   run(new_connector = \(env) {
#'     connector_fs(withr::local_tempdir(.local_envir = env))
#'   })
#' @export
connector_contract_tests <- function(cases = connector_contract_cases()) {
  ConnectorContract$new(cases)
}

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
#' @return `connector_contract_cases()`: a named list of named lists of
#'   functions.
#' @rdname connector_contract_tests
#' @export
connector_contract_cases <- function(
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

  expect_returns_cnt <- function(returned, cnt, call) {
    testthat::expect_identical(
      returned,
      cnt,
      label = paste(call, "return value"),
      expected.label = "the connector"
    )
  }

  list(
    write_cnt = list(
      "returns the connector" = function(cnt) {
        # Act
        returned <- write_cnt(cnt, data, name)

        # Assert
        expect_returns_cnt(returned, cnt, "write_cnt(cnt, data, name)")
      }
    ),
    read_cnt = list(
      "returns the written data" = function(cnt) {
        # Arrange
        write_cnt(cnt, data, name)

        # Act
        read_data <- read_cnt(cnt, name)

        # Assert
        expect_read_back(object = read_data, expected = data)
      },
      "errors on missing content" = function(cnt) {
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
      "lists written content" = function(cnt) {
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
      "returns the connector and removes content" = function(cnt) {
        # Arrange
        write_cnt(cnt, data, name)

        # Act
        returned <- remove_cnt(cnt, name)

        # Assert
        expect_returns_cnt(returned, cnt, "remove_cnt(cnt, name)")
        testthat::expect_false(
          name %in% list_content_cnt(cnt),
          info = paste0("remove_cnt() should remove \"", name, "\"")
        )
      }
    ),
    create_directory_cnt = list(
      "with open = FALSE returns the connector" = function(cnt) {
        # Act
        returned <- create_directory_cnt(cnt, "contract_dir", open = FALSE)

        # Assert
        expect_returns_cnt(returned, cnt, "create_directory_cnt(open = FALSE)")
        testthat::expect_contains(list_content_cnt(cnt), "contract_dir")
      },
      "with open = TRUE returns a new connector" = function(cnt) {
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
      "returns the connector and removes it" = function(cnt) {
        # Arrange
        create_directory_cnt(cnt, "contract_dir", open = FALSE)

        # Act
        returned <- remove_directory_cnt(cnt, "contract_dir")

        # Assert
        expect_returns_cnt(
          returned,
          cnt,
          "remove_directory_cnt(cnt, \"contract_dir\")"
        )
        testthat::expect_false(
          "contract_dir" %in% list_content_cnt(cnt),
          info = "remove_directory_cnt() should remove \"contract_dir\""
        )
      }
    ),
    download_cnt = list(
      "returns the connector and creates a file" = function(cnt) {
        # Arrange
        write_cnt(cnt, data, name)
        # ponytail: plain tempfile, left in session tempdir if test fails
        dest <- tempfile(fileext = paste0(".", tools::file_ext(name)))

        # Act
        returned <- download_cnt(cnt, src = name, dest = dest)

        # Assert
        expect_returns_cnt(
          returned,
          cnt,
          "download_cnt(cnt, src = name, dest = dest)"
        )
        testthat::expect_true(
          file.exists(dest),
          info = paste0("download_cnt() should create \"", dest, "\"")
        )
        unlink(dest)
      }
    ),
    upload_cnt = list(
      "returns the connector and adds content" = function(cnt) {
        # Arrange
        # ponytail: plain tempfile, left in session tempdir if test fails
        src <- tempfile(fileext = paste0(".", tools::file_ext(name)))
        write_file(data, src)
        dest <- paste0("uploaded_", name)

        # Act
        returned <- upload_cnt(cnt, src = src, dest = dest)

        # Assert
        expect_returns_cnt(
          returned,
          cnt,
          "upload_cnt(cnt, src = src, dest = dest)"
        )
        testthat::expect_contains(list_content_cnt(cnt), dest)
        unlink(src)
      }
    )
  )
}

#' Connector contract test suite
#'
#' @description
#' A suite of contract cases grouped by connector method. Create one with
#' [connector_contract_tests()], which describes the default cases and how to
#' run them.
ConnectorContract <- R6::R6Class(
  classname = "ConnectorContract",
  public = list(
    #' @description
    #' Create a suite. Prefer [connector_contract_tests()].
    #' @param cases Named list of named lists of `function(cnt)`, grouped by
    #'   method.
    initialize = function(cases = list()) {
      checkmate::assert_list(cases, types = "list", names = "unique")
      for (method in names(cases)) {
        for (name in names(cases[[method]])) {
          self$add_case(method, name, cases[[method]][[name]])
        }
      }
    },

    #' @description
    #' Get one case, e.g. to debug it.
    #' @param method Name of the connector method.
    #' @param name Case name.
    #' @return The case, a `function(cnt)`.
    get_case = function(method, name) {
      private$assert_case(method, name)
      private$.cases[[method]][[name]]
    },

    #' @description
    #' Add a case under a method.
    #' @param method Name of the connector method the case tests.
    #' @param name Case name, describing the expected behaviour. Unique within
    #'   the method.
    #' @param case A `function(cnt)` running expectations against a new,
    #'   empty connector.
    #' @return The suite, invisibly.
    add_case = function(method, name, case) {
      checkmate::assert_string(method)
      checkmate::assert_string(name)
      checkmate::assert_function(case, args = "cnt")
      if (name %in% names(private$.cases[[method]])) {
        cli::cli_abort("Case {.val {name}} is already in {.fun {method}}.")
      }
      private$.cases[[method]][[name]] <- case
      invisible(self)
    },

    #' @description
    #' Remove one case.
    #' @param method Name of the connector method.
    #' @param name Case name.
    #' @return The suite, invisibly.
    remove_case = function(method, name) {
      private$assert_case(method, name)
      private$.cases[[method]][[name]] <- NULL
      if (length(private$.cases[[method]]) == 0) {
        private$.cases[[method]] <- NULL
      }
      invisible(self)
    },

    #' @description
    #' Remove all of a method's cases, e.g. for a method the backend does not
    #' support.
    #' @param method Name of the connector method.
    #' @return The suite, invisibly.
    remove_method = function(method) {
      private$assert_method(method)
      private$.cases[[method]] <- NULL
      invisible(self)
    },

    #' @description
    #' Run every case as its own [testthat::test_that()], named
    #' `"connector contract: <method>() <case>"`.
    #' @param new_connector `function(env)` returning a new, empty connector.
    #'   Any cleanup must be tied to `env`, e.g. with
    #'   `withr::local_tempdir(.local_envir = env)`, so it runs when each test
    #'   ends.
    #' @param reporter `NULL` to report to the active `testthat` reporter, as
    #'   in a package's test files. Or a [testthat::Reporter] to report the
    #'   cases on their own. Defaults to `NULL` inside a `testthat` run and to
    #'   a progress reporter that prints a summary outside one, e.g. in the
    #'   console.
    #' @return The suite, invisibly.
    run = function(
      new_connector,
      reporter = if (testthat::is_testing()) {
        NULL
      } else {
        testthat::ProgressReporter$new(show_praise = FALSE)
      }
    ) {
      rlang::check_installed("testthat")
      checkmate::assert_function(new_connector, args = "env")
      checkmate::assert_r6(reporter, "Reporter", null.ok = TRUE)

      run_cases <- function() {
        for (method in names(private$.cases)) {
          for (case in names(private$.cases[[method]])) {
            test_case <- private$.cases[[method]][[case]]
            test_name <- paste0("connector contract: ", method, "() ", case)
            testthat::test_that(test_name, {
              # Create the connector here, not as a lazy argument, so it exists
              # and is cleaned up even when a case never uses it
              cnt <- new_connector(env = environment())
              test_case(cnt)
            })
          }
        }
      }

      if (is.null(reporter)) {
        run_cases()
      } else {
        testthat::with_reporter(reporter, {
          reporter$start_file("connector contract")
          reporter$start_context("connector contract")
          run_cases()
          reporter$end_context("connector contract")
          reporter$end_file()
        })
      }
      invisible(self)
    },

    #' @description
    #' Print the cases grouped by method.
    #' @param ... Not used.
    #' @return The suite, invisibly.
    print = function(...) {
      cases <- lapply(private$.cases, names)
      n <- length(unlist(cases))
      cli::cli_text("{.cls ConnectorContract} with {n} case{?s}")
      for (method in names(cases)) {
        cli::cli_text("{.fun {method}}")
        for (case in cases[[method]]) {
          cli::cli_bullets(c("*" = "{case}"))
        }
      }
      invisible(self)
    }
  ),
  private = list(
    .cases = list(),

    assert_method = function(method) {
      checkmate::assert_string(method)
      if (!method %in% names(private$.cases)) {
        cli::cli_abort("Method {.fun {method}} is not in the suite.")
      }
    },

    assert_case = function(method, name) {
      private$assert_method(method)
      checkmate::assert_string(name)
      if (!name %in% names(private$.cases[[method]])) {
        cli::cli_abort("Case {.val {name}} is not in {.fun {method}}.")
      }
    }
  )
)
