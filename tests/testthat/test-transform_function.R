# Mock function to create a clean_fct_info object
create_mock_clean_fct_info <- function() {
  structure(
    list(
      function_name = "lm",
      parameters = list(
        formula = "y ~ x",
        data = "df"
      ),
      package_name = "stats"
    ),
    class = "clean_fct_info"
  )
}

test_that("transform_as_backend works correctly", {
  # Test 1: Correct input
  mock_info <- create_mock_clean_fct_info()
  result <- transform_as_backend(mock_info, "linear_model")

  expect_type(result, "list")
  expect_equal(result$name, "linear_model")
  expect_equal(result$backend$type, "stats::lm")
  expect_equal(result$backend$formula, "y ~ x")
  expect_equal(result$backend$data, "df")

  # Test 2: Incorrect input class
  expect_error(
    transform_as_backend(list(), "wrong_input"),
    "You should use the extract_function_info function before calling this function"
  )
})

test_that("transform_as_datasources works correctly", {
  # Create mock backends
  mock_info1 <- create_mock_clean_fct_info()
  mock_info2 <- create_mock_clean_fct_info()
  mock_info2$function_name <- "glm"

  backend1 <- transform_as_backend(mock_info1, "linear_model")
  backend2 <- transform_as_backend(mock_info2, "logistic_model")

  # Test
  result <- datasources(list(backend1, backend2))

  expect_type(result, "list")
  expect_s3_class(result, "connector::datasources")
  expect_null(names(result))
  expect_length(result, 2)
  expect_equal(result[[1]]$name, "linear_model")
  expect_equal(result[[2]]$name, "logistic_model")
})
