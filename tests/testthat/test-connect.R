test_that("Connect datasources to the connections for a yaml file", {
  # create the connections
  cnts <- connect(yaml_file)

  expect_s3_class(cnts, "connectors")
  expect_named(cnts, c("adam", "sdtm"))

  ## write and read for a system file
  withr::with_options(list(readr.show_col_types = FALSE), {
    cnts$adam$cnt_read("adsl.csv") %>%
      expect_s3_class("data.frame")
    expect_error(cnts$adam$cnt_read("do_not_exits.csv"))

    cnts$adam$cnt_write(data.frame(a = 1:10, b = 11:20), "example.csv") %>%
      expect_no_error()

    expect_no_error(cnts$adam$cnt_read("example.csv"))
    expect_no_error(cnts$adam$cnt_remove("example.csv"))
    expect_error(cnts$adam$cnt_read("example.csv"))
  })

  ## write and read for a dbi connection
  expect_no_error(cnts$sdtm$cnt_write(iris, "iris"))

  expect_no_error(cnts$sdtm$cnt_read("iris"))

  ## Manipulate a table with the database

  iris_f <- cnts$sdtm$cnt_tbl("iris") %>%
    dplyr::filter(Sepal.Length > 5)

  expect_s3_class(iris_f, "tbl_dbi")

  expect_snapshot(iris_f %>% dplyr::collect())
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

  # Run below with already set "hello" env var

  withr::with_envvar(
    new = c(hello = "test", RSQLite_db = "", system_path = ""),
    code = {
      Sys.unsetenv(c("RSQLite_db", "system_path"))

      yaml_file_env |>
        read_file(eval.expr = TRUE) |>
        assert_config() |>
        parse_config(set_env = FALSE) |>
        expect_message("Inconsistencies between existing environment variables and env entries:") |>
        suppressMessages() # Not print the bullets to the test log

      yaml_file_env |>
        read_file(eval.expr = TRUE) |>
        assert_config() |>
        parse_config() |>
        expect_message("Overwriting already set environment variables:") |>
        suppressMessages() # Not print the bullets to the test log
    }
  )
})
