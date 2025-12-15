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

test_that("find_file() integration in read_cnt()", {
  withr::local_options(
    connector.verbosity_level = "verbose"
  )

  tmp <- withr::local_tempdir()

  x <- connector_fs(path = tmp)
  x$write_cnt(iris, "iris.xlsx")
  x$write_cnt(mtcars, name = "mtcars.xlsx")

  msg <- x$read_cnt("iris") |>
    expect_message(regexp = "Found one file:")

  x$write_cnt(iris, "iris.parquet")

  err <- x$read_cnt("iris") |>
    expect_error(regexp = "Found several files with the same name:")

  err$message |>
    expect_match("iris\\.xlsx") |>
    expect_match("iris\\.parquet")

  x$read_cnt("iris.parquet") |>
    expect_no_condition()

  file.copy(
    from = file.path(tmp, "iris.xlsx"),
    to = file.path(tmp, "iris.xlsx.backup")
  )

  x$read_cnt("iris.xlsx") |>
    expect_no_condition()

  withr::with_options(
    new = list(connector.default_ext = "parquet"),
    code = x$read_cnt("iris")
  ) |>
    expect_message(regexp = "Found one file with default")

  x$read_cnt("does_not_exist.xlsx") |>
    expect_error(regexp = "No file found")
})
