test_that("Test utils for file", {
  ## Supported Fs
  expect_snapshot(supported_fs())

  # test error for extension
  expect_error(error_extension())

  expect_snapshot_error(error_extension())

  # Example for extension
  expect_snapshot(example_read_ext())

  ## find file
  temp_dir <- tempdir()
  expect_error(
    find_file("test", temp_dir)
  )

  file.create(
    c(file.path(temp_dir, "test.txt"), file.path(temp_dir, "test.csv"))
  )

  expect_error(
    find_file("test", temp_dir)
  )
})
