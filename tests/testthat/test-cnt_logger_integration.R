test_that("ConnectorLogger integration test with whirl", {
  skip_on_cran()

  dir_ <- withr::local_tempdir("connector_logger_test")

  file.copy(
    file.path(test_path("scripts"), "example.R"),
    file.path(dir_, "example.R")
  )

  file.copy(
    file.path(test_path("configs"), "_whirl.yml"),
    file.path(dir_, "_whirl.yml")
  )

  file.copy(
    file.path(test_path("configs"), "_whirl_connector.yml"),
    file.path(dir_, "_connector.yml")
  )

  res <- withr::with_dir(
    new = dir_,
    code = {
      whirl::run(
        input = "_whirl.yml",
        check_renv = FALSE
      )
    }
  ) |>
    expect_no_error()

  list.files(dir_) |>
    expect_contains(c("summary.html", "example_log.html"))

  res$result[[1]]$files |>
    expect_type("list") |>
    expect_length(3) |>
    names() |>
    expect_contains(c("read", "write", "delete"))
})
