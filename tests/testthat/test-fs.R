test_that("fs connector", {
  t_dir <- withr::local_tempdir()
  t_file1 <- withr::local_tempfile(lines = "hello", fileext = ".txt")
  t_file2 <- withr::local_tempfile(fileext = ".txt")

  fs <- ConnectorFS$new(path = t_dir) |>
    expect_no_condition()

  fs$list_content_cnt() |>
    expect_vector(ptype = character(), size = 0)

  fs$write_cnt(mtcars, "mtcars.rds") |>
    expect_no_condition()

  fs$list_content_cnt() |>
    expect_vector(ptype = character(), size = 1)

  fs$read_cnt("mtcars.rds") |>
    expect_equal(mtcars)

  fs$tbl_cnt("mtcars.rds") |>
    expect_equal(mtcars)

  fs$path |>
    expect_vector(ptype = character(), size = 1)

  fs$remove_cnt("mtcars.rds") |>
    expect_no_condition()

  fs$list_content_cnt() |>
    expect_vector(ptype = character(), size = 0)

  new_directory <- fs$create_directory_cnt("new_dir")

  checkmate::assert_r6(new_directory, classes = "ConnectorFS")
  testthat::expect_true(basename(new_directory$path) == "new_dir")

  fs$list_content_cnt("new_dir") |>
    expect_vector(ptype = character(), size = 1)

  fs$remove_directory_cnt("new_dir")

  fs$list_content_cnt("new_dir") |>
    expect_vector(ptype = character(), size = 0)

  fs$upload_cnt(file = t_file1, name = "t_file.txt")
  fs$list_content_cnt("t_file.txt") |>
    expect_vector(ptype = character(), size = 1)
  fs$read_cnt("t_file.txt") |>
    expect_equal("hello")

  fs$download_cnt("t_file.txt", file = t_file2)
  readr::read_lines(t_file2) |>
    expect_equal("hello")

  # clean up
  withr::deferred_clear()
  unlink(t_dir, recursive = TRUE)
})
