test_that("Create a backend for generic backend", {
  only_one <- yaml_content_parsed |>
    purrr::pluck("connections", 1, "backend")

  connection <- create_backend(only_one)

  expect_s3_class(connection, c("Connector_fs", "R6"))

  ## Error because of params

  wrong_backend <- only_one
  wrong_backend$a_random_param <- "a_random_param"

  expect_error(create_backend(wrong_backend))
})
