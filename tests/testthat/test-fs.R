test_that("fs connector", {
  t_dir <- withr::local_tempdir()
  fs <- connector_fs(path = t_dir) |>
    expect_no_condition()

  fs$list_content() |>
    expect_vector(ptype = character(), size = 0)

  fs$write(mtcars, "mtcars.rds") |>
    expect_no_condition()

  fs$list_content() |>
    expect_vector(ptype = character(), size = 1)


  fs$read("mtcars.rds") |>
    expect_equal(mtcars)

  fs$construct_path("test.rds") |>
    expect_vector(ptype = character(), size = 1)

  fs$remove("mtcars.rds") |>
    expect_no_condition()

  fs$list_content() |>
    expect_vector(ptype = character(), size = 0)

  # clean up
  withr::deferred_clear()
  unlink(t_dir, recursive = TRUE)
})
