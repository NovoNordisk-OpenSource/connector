test_that("DBI generics work on local SQLite database", {

  test <- connector_dbi$new(drv = RSQLite::SQLite(), dbname = withr::local_tempfile())

  x <- mtcars
  x$car <- rownames(x)
  rownames(x) <- NULL

  test$list_content() |>
    expect_equal(character(0))

  test$write(x, "mtcars") |>
    expect_true()

  test$write(x, "mtcars") |>
    expect_error()

  test$list_content() |>
    expect_equal("mtcars")

  test$read("mtcars") |>
    expect_equal(x)

  test$write(x, "mtcars", overwrite = TRUE) |>
    expect_true()

  test$tbl("mtcars") |>
    dplyr::filter(car == "Mazda RX4") |>
    dplyr::select(car, mpg) |>
    dplyr::collect() |>
    expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

  test$get_conn() |>
    DBI::dbGetQuery("SELECT * FROM mtcars") |>
    expect_equal(x)

  test$disconnect() |>
    expect_true()

  test$read("mtcars") |>
    expect_error("Invalid or closed connection")

})
