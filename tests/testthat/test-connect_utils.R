test_that("change_to_new_metadata works correctly", {
  # Test case 1: Basic functionality
  old_meta <- list(a = 1, b = 2, c = 3)
  new_meta <- list(b = 20, d = 40)
  result <- change_to_new_metadata(old_meta, new_meta)
  expect_equal(result, list(a = 1, b = 20, c = 3, d = 40))

  # Test case 2: Empty old_metadata
  result <- change_to_new_metadata(list(), new_meta)
  expect_equal(result, new_meta)

  # Test case 3: NULL old_metadata
  result <- change_to_new_metadata(NULL, new_meta)
  expect_equal(result, new_meta)

  # Test case 4: Empty new_metadata
  result <- change_to_new_metadata(old_meta, list())
  expect_equal(result, old_meta)

  # Test case 5a: Overwriting all old metadata
  new_meta <- list(a = 10, b = 20, c = 30)
  result <- change_to_new_metadata(old_meta, new_meta)
  expect_equal(result, new_meta)

  # Test case 5: Overwriting all old metadata and add new
  new_meta <- list(a = 10, b = 20, c = 30, d = 50)
  result <- change_to_new_metadata(old_meta, new_meta)
  expect_equal(result, new_meta)

  # Test case 6: Mixed data types
  old_meta <- list(a = 1, b = "two", c = TRUE)
  new_meta <- list(b = "new", d = FALSE)
  result <- change_to_new_metadata(old_meta, new_meta)
  expect_equal(result, list(a = 1, b = "new", c = TRUE, d = FALSE))

  # Test case 7: Nested lists
  old_meta <- list(a = 1, b = list(x = 10, y = 20))
  new_meta <- list(b = list(x = 100, z = 300))
  result <- change_to_new_metadata(old_meta, new_meta)
  expect_equal(result, list(a = 1, b = list(x = 100, z = 300)))

  # Test case 8: Error handling - invalid input types
  expect_error(change_to_new_metadata("not a list", new_meta), "Assertion on 'old_metadata' failed")
  expect_error(change_to_new_metadata(old_meta, "not a list"), "Assertion on 'new_metadata' failed")

  # Test case 9: Error handling - non-unique names
  expect_error(change_to_new_metadata(list(a = 1, a = 2), new_meta), "Assertion on 'old_metadata' failed")
  expect_error(change_to_new_metadata(old_meta, list(b = 20, b = 30)), "Assertion on 'new_metadata' failed")
})
