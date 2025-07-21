test_that("fs connector", {
  t_dir <- withr::local_tempdir()
  t_file1 <- withr::local_tempfile(lines = "hello", fileext = ".txt")
  t_file2 <- withr::local_tempfile(fileext = ".txt")
  t_dir2 <- withr::local_tempdir()

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

  fs$write_cnt(mtcars, "mtcars") |>
    expect_no_condition()

  withr::with_options(
    new = list("connector.default_ext" = "parquet"),
    code = fs$write_cnt(mtcars, "mtcars")
  ) |>
    expect_no_condition()

  fs$list_content_cnt() |>
    sort() |>
    expect_equal(sort(c("mtcars.parquet", "mtcars.csv")))

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

  testtxt <- "this is a test"
  writeLines(testtxt, file.path(t_dir2, "test.txt"))
  fs$upload_directory_cnt(t_dir2, name = "newdir")
  fs$list_content_cnt("newdir") |>
    expect_vector(ptype = character(), size = 1)
  fs$path |>
    file.path("newdir/test.txt") |>
    readLines() |>
    expect_equal(testtxt)

  fs$download_directory_cnt("newdir", t_dir2) |>
    expect_no_condition()

  list.files(t_dir2) |>
    expect_contains("newdir")

  file.path(t_dir2, "newdir", "test.txt") |>
    readLines() |>
    expect_equal(testtxt)

  # clean up
  withr::deferred_clear()
  unlink(t_dir, recursive = TRUE)
})
