test_that("Correct error handling and creation", {
  nested_connectors() |>
    expect_error("At least one connectors object must be supplied")

  nested_connectors(a = mtcars) |>
    expect_error("All elements must be a connectors object")

  nested_connectors(
    a = connector_fs(withr::local_tempdir()),
    b = connectors(a = connector_fs(withr::local_tempdir()))
  ) |>
    expect_error("All elements must be a connectors object")

  nested_connectors(a = connectors(a = connector_fs(withr::local_tempdir()))) |>
    expect_no_error() |>
    expect_length(1)
})
