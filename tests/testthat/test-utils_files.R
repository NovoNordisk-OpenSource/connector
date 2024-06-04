test_that("Test utils for file", {
  # test error for extension
  expect_error(error_extension())
  expect_snapshot_error(error_extension())

  # Example for extension
  expect_snapshot_output(example_read_ext())

  ## Supported Fs
  expect_snapshot_output(supported_fs())

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
