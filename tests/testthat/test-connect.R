test_that("Connect datasources to the connections for a yaml file", {
  # create the connections
  cnts <- connect(yaml_file)

  expect_s3_class(cnts, "connectors")
  expect_named(cnts, c("adam", "sdtm"))

  ## write and read for a system file
  withr::with_options(list(readr.show_col_types = FALSE), {
    cnts$adam$read_cnt("adsl.csv") |>
      expect_s3_class("data.frame")
    expect_error(cnts$adam$read_cnt("do_not_exits.csv"))

    cnts$adam$write_cnt(data.frame(a = 1:10, b = 11:20), "example.csv") |>
      expect_no_error()

    expect_no_error(cnts$adam$read_cnt("example.csv"))
    expect_no_error(cnts$adam$remove_cnt("example.csv"))
    expect_error(cnts$adam$read_cnt("example.csv"))
  })

  ## write and read for a dbi connection
  expect_no_error(cnts$sdtm$write_cnt(iris, "iris"))

  expect_no_error(cnts$sdtm$read_cnt("iris"))

  ## Manipulate a table with the database

  iris_f <- cnts$sdtm$tbl_cnt("iris") |>
    dplyr::filter(Sepal.Length > 5)

  expect_s3_class(iris_f, "tbl_dbi")

  expect_snapshot(dplyr::collect(iris_f))
})

test_that("Tools for yaml parsinbg", {
  glue_if_character("var {var}", var = "a") |>
    expect_equal("var a")

  glue_if_character(1, var = "a") |>
    expect_equal(1)

  parse_config_helper(
    content = list(list("{v.a}"), list(c("{v.b}", "{v.c}"))),
    input = list(v = c(a = "1", b = "2", c = "3"))
  ) |>
    expect_equal(list(list("1"), list(c("2", "3"))))
})

test_that("yaml config parsed correctly", {
  read_file(yaml_file, eval.expr = TRUE) |>
    expect_no_condition()

  # Run with no env vars set

  if (getRversion() >= as.package_version("4.4.1")) {
    withr::with_envvar(
      new = list(hello = "", RSQLite_db = "", system_path = ""),
      code = {
        Sys.unsetenv(c("hello", "RSQLite_db", "system_path"))
        yaml_file_env |>
          read_file(eval.expr = TRUE) |>
          assert_config() |>
          parse_config() |>
          expect_no_condition()
      }
    )
  }

  # Run below with already set "hello" env var
  if (getRversion() >= as.package_version("4.4.1")) {
    withr::with_envvar(
      new = c(hello = "test", RSQLite_db = "", system_path = ""),
      code = {
        Sys.unsetenv(c("RSQLite_db", "system_path"))

        withr::local_options(
          list(zephyr.verbosity_level = "verbose")
        )

        yaml_file_env |>
          read_file(eval.expr = TRUE) |>
          assert_config() |>
          parse_config(set_env = FALSE) |>
          expect_message(
            "Inconsistencies between existing environment variables and env entries:"
          ) |>
          suppressMessages() # Not print the bullets to the test log

        yaml_file_env |>
          read_file(eval.expr = TRUE) |>
          assert_config() |>
          parse_config() |>
          expect_message("Overwriting already set environment variables:") |>
          suppressMessages() # Not print the bullets to the test log
      }
    )
  }
})

testthat::test_that("Using a list instead of yaml", {
  # using yaml already parsed as list
  connect(yaml_content_raw) |>
    expect_no_error()
})

testthat::test_that("Using a json instead of yaml", {
  # using json file
  connect(test_path("configs", "config_json.json")) |>
    expect_no_error()
})

testthat::test_that("Using and uptade metadata", {
  test_list <- connect(
    yaml_content_raw,
    metadata = list(extra_class = "test_from_metadata")
  ) |>
    expect_no_error()

  expect_s3_class(test_list$adam, "test_from_metadata")

  test_yaml <- connect(
    yaml_file,
    metadata = list(extra_class = "test_from_metadata")
  ) |>
    expect_no_error()

  expect_s3_class(test_yaml$adam, "test_from_metadata")
})

test_that("Add logs to connectors object", {
  # whirl needs to be installed to pass this test - if not available
  # then skip the test
  testthat::skip_if_not_installed("whirl")

  cnts <- connect(yaml_file, logging = TRUE)

  lapply(cnts, function(x) {
    expect_s3_class(x, "Connector")
    expect_true(
      all(
        c("read_cnt", "write_cnt", "remove_cnt", "list_content_cnt") %in%
          names(x$.__enclos_env__$self)
      )
    )
    expect_equal(class(x$read_cnt), "function")
  })

  lapply(cnts, function(x) {
    expect_s3_class(x, "ConnectorLogger")
  })
})
