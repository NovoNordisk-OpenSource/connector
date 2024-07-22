test_that("fs connector", {
  t_dir <- withr::local_tempdir()
  t_file1 <- withr::local_tempfile(lines = "hello", fileext = ".txt")
  t_file2 <- withr::local_tempfile(fileext = ".txt")

  fs <- connector_fs$new(path = t_dir) |>
    expect_no_condition()

  fs$cnt_list_content() |>
    expect_vector(ptype = character(), size = 0)

  fs$cnt_write(mtcars, "mtcars.rds") |>
    expect_no_condition()

  fs$cnt_list_content() |>
    expect_vector(ptype = character(), size = 1)

  fs$cnt_read("mtcars.rds") |>
    expect_equal(mtcars)

  fs$path |>
    expect_vector(ptype = character(), size = 1)

  fs$cnt_remove("mtcars.rds") |>
    expect_no_condition()

  fs$cnt_list_content() |>
    expect_vector(ptype = character(), size = 0)

  fs$cnt_create_directory("new_dir")

  fs$cnt_list_content("new_dir") |>
    expect_vector(ptype = character(), size = 1)

  fs$cnt_remove_directory("new_dir")

  fs$cnt_list_content("new_dir") |>
    expect_vector(ptype = character(), size = 0)

  fs$cnt_upload(file = t_file1, name = "t_file.txt")
  fs$cnt_list_content("t_file.txt") |>
    expect_vector(ptype = character(), size = 1)
  fs$cnt_read("t_file.txt") |>
    expect_equal("hello")

  fs$cnt_download("t_file.txt", file = t_file2)
  readr::read_lines(t_file2) |>
    expect_equal("hello")

  # clean up
  withr::deferred_clear()
  unlink(t_dir, recursive = TRUE)
})
