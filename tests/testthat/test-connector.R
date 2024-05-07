test_that("can create connector", {

  system.file("config", "default_config.yaml", package = "connector") |>
    connect() |>
    expect_s3_class("connector")

})

