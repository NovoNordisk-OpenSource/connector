test_that("extract_function_info works for standard functions", {
  result <- extract_function_info("stats::lm(formula = y ~ x, data = df)")

  expect_s3_class(result, "clean_fct_info")
  expect_equal(result$function_name, "lm")
  expect_equal(result$package_name, "stats")
  expect_false(result$is_r6)
  expect_equal(result$parameters, list(formula = "y ~ x", data = "df"))
})

test_that("extract_function_info works for R6 class constructors", {
  # Mocking an R6 class for testing
  call_ <- deparse(substitute(connector$new(extra_class = "test")))
  result <- extract_function_info(call_)

  expect_s3_class(result, "clean_fct_info")
  expect_equal(result$function_name, "connector")
  expect_true(result$is_r6)
  expect_equal(result$parameters, list(extra_class = "test"))
})

test_that("extract_base_info correctly extracts package and function names", {
  result1 <- extract_base_info("stats::lm", FALSE)
  expect_equal(result1, list(package_name = "stats", func_name = "lm"))

  result2 <- extract_base_info("connector$new", TRUE)
  expect_equal(result2, list(package_name = c(name = "connector"), func_name = "connector"))
})

test_that("get_standard_specific_info works correctly", {
  result <- get_standard_specific_info("stats", "lm")
  expect_type(result$func, "closure")
  expect_true("formula" %in% result$formal_args)
})

test_that("extract_and_process_params handles named and unnamed parameters", {
  expr <- rlang::parse_expr("lm(y ~ x, data = df, 42)")
  formal_args <- c("formula", "data", "subset", "weights")

  result <- extract_and_process_params(expr, formal_args)
  expect_equal(result, list(data = "df", formula = "y ~ x", subset = "42"))
})

test_that("process_ellipsis_params handles ... correctly", {
  params <- list(x = 1, y = 2, 3, 4)
  result <- process_ellipsis_params(params)
  expect_equal(result, list(x = 1, y = 2, ... = structure(c(3, 4), names = c("", ""))))
})

test_that("process_named_params matches unnamed args correctly", {
  params <- list(x = 1, z = 2, 3)
  formal_args <- c("x", "y", "z")
  result <- process_named_params(params, formal_args)
  expect_equal(result, list(x = 1, z = 2, y = 3))
})
