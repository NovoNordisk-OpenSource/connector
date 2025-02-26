test_that("Create a backend for DBI", {
  only_one <- yaml_content_parsed |>
    purrr::pluck("datasources", 2, "backend")

  connection <- create_backend_dbi(only_one)

  expect_s3_class(connection, c("ConnectorDBI", "R6"))
})
