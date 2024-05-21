
test_that("fs connector", {

  fs <- connector_fs$new(path = withr::local_tempdir()) |>
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
})


