test_that("ConnectorLogger integration test with whirl", {
  dir_tmp <- tempdir()
  dir.create(path = file.path(dir_tmp, "connector_whirl"))
  dir_ <- file.path(dir_tmp, "connector_whirl")
  # copy files for test
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

  withr::with_dir(dir_, {
    expect_no_error(
      whirl::run("_whirl.yml")
    )

    expect_equal(
      length(list.files(".")),
      6
    )

    expect_true(
      file.exists(
        "example_msg_log.json"
      )
    )

    con <- file(description = "example_msg_log.json", open = "r")
    log_info <- jsonlite::stream_in(con)

    expect_length(log_info, 3)
    log_info$time <- NULL
    log_info$file <- NULL

    expect_snapshot(log_info)
  })

  # Clean folder
  unlink(dir_, recursive = TRUE, force = TRUE)
})
