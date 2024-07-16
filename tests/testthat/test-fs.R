test_that("fs connector", {
  t_dir <- withr::local_tempdir()
  t_file1 <- withr::local_tempfile(lines = "hello", fileext = ".txt")
  t_file2 <- withr::local_tempfile(fileext = ".txt")

  fs <- connector_fs$new(path = t_dir) |>
    expect_no_condition()

  fs$list_content() |>
    expect_vector(ptype = character(), size = 0)

  fs$write(mtcars, "mtcars.rds") |>
    expect_no_condition()

  fs$list_content() |>
    expect_vector(ptype = character(), size = 1)

  fs$read("mtcars.rds") |>
    expect_equal(mtcars)

  fs$path |>
    expect_vector(ptype = character(), size = 1)

  fs$remove("mtcars.rds") |>
    expect_no_condition()

  fs$list_content() |>
    expect_vector(ptype = character(), size = 0)

  fs$create_directory("new_dir")

  fs$list_content("new_dir") |>
    expect_vector(ptype = character(), size = 1)

  fs$remove_directory("new_dir")

  fs$list_content("new_dir") |>
    expect_vector(ptype = character(), size = 0)

  fs$upload(file = t_file1, name = "t_file.txt")
  fs$list_content("t_file.txt") |>
    expect_vector(ptype = character(), size = 1)
  fs$read("t_file.txt") |>
    expect_equal("hello")

  fs$download("t_file.txt", file = t_file2)
  readr::read_lines(t_file2) |>
    expect_equal("hello")

  # clean up
  withr::deferred_clear()
  unlink(t_dir, recursive = TRUE)
})
