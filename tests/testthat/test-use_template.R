test_that("Testing use_template", {
  withr::with_tempdir(pattern = "test_use_template", {
    rlang::local_interactive(FALSE)

    usethis::create_project(path = ".") |>
      expect_message() |>
      suppressMessages()

    use_template("readme.yml", config_file = "_connector.yml") |>
      expect_message() |>
      suppressMessages()

    config_file_path <- "_connector.yml"
    expect_true(file.exists(config_file_path))
    expect_snapshot(readLines(config_file_path))
  })
})
