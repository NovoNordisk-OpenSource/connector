cli::test_that_cli("test example_read", {
  expect_snapshot_out(example_read_ext())
})

cli::test_that_cli("test example_read", {
  expect_snapshot_error(error_extension())
})

test_that("Test utils for file", {
  ## Supported Fs
  expect_snapshot(supported_fs())

  # test error for extension
  expect_error(error_extension())

  ## find file
  temp_dir <- withr::local_tempdir()
  expect_error(
    find_file("test", temp_dir)
  )

  file.create(
    c(file.path(temp_dir, "test.txt"), file.path(temp_dir, "test.csv"))
  )

  withr::with_options(
    new = list(connector.default_ext = ""),
    code = find_file("test", temp_dir)
  ) |>
    expect_error()

  withr::with_options(
    new = list(connector.default_ext = "txt"),
    code = find_file("test", temp_dir)
  ) |>
    expect_no_error() |>
    basename() |>
    expect_equal("test.txt")
})
