test_that("Tools for yaml parsinbg", {
  glue_if_character("var {var}", var = "a") |>
    expect_equal("var a")

  glue_if_character(1, var = "a") |>
    expect_equal(1)

  parse_config(
    content = list(list("{v.a}"), list(c("{v.b}", "{v.c}"))),
    input = list(v = c(a = "1", b = "2", c = "3"))
  ) |>
    expect_equal(list(list("1"), list(c("2", "3"))))
})


test_that("Read yaml config", {
  read_yaml_config(file = yaml_file) |>
    expect_no_condition()

  # Run with no env vars set

  withr::with_envvar(
    new = list(hello = "", RSQLite_db = "", system_path = ""),
    code = {
      Sys.unsetenv(c("hello", "RSQLite_db", "system_path"))
      read_yaml_config(file = yaml_file_env) |>
        expect_no_condition()
    }
  )

  # Run below with already set "hello" env var

  withr::with_envvar(
    new = c(hello = "test", RSQLite_db = "", system_path = ""),
    code = {
      Sys.unsetenv(c("RSQLite_db", "system_path"))

      read_yaml_config(file = yaml_file_env, set_env = FALSE) |>
        expect_message("Inconsistencies between existing environment variables and env entries:") |>
        suppressMessages() # Not print the bullets to the test log

      read_yaml_config(file = yaml_file_env) |>
        expect_message("Overwriting already set environment variables:") |>
        suppressMessages() # Not print the bullets to the test log
    }
  )
})
