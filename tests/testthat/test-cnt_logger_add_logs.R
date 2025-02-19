test_that("add_logs functions correctly", {
  # Test 1: Check if the function throws an error when the argument is not of class "connectors"
  expect_error(add_logs(list()))

  # Test 2: Verify that the function correctly adds the "connector_logger" class
  mock_connectors <- structure(list(list(name = "conn1"), list(name = "conn2")), class = "connectors")

  result <- add_logs(mock_connectors)

  expect_s3_class(result, "connectors")
  expect_length(result, 2)
  expect_true(all(sapply(result, function(x) {
    "connector_logger" %in% class(x)
  })))

  # Test 3: Check if the function preserves existing classes
  mock_connectors_with_class <- structure(list(
    structure(list(name = "conn1"), class = "existing_class"),
    structure(
      list(name = "conn2"),
      class = c("another_class", "yet_another_class")
    )
  ), class = "connectors")

  result_with_class <- add_logs(mock_connectors_with_class)

  expect_true("existing_class" %in% class(result_with_class[[1]]))
  expect_true(all(
    c("another_class", "yet_another_class") %in% class(result_with_class[[2]])
  ))
})
