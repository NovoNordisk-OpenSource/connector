# general test data for DBI connections
x <- mtcars
x$car <- rownames(x)
rownames(x) <- NULL

# Connections to be tested

specs <- list(
  sqlite = list(
    drv = RSQLite::SQLite(),
    dbname = withr::local_tempfile()
  ),
  postgres = list(
    drv = RPostgres::Postgres(),
    dbname = "postgres",
    user = "postgres",
    password = "password",
    port = 5432,
    host = "localhost"
  )
)

test_that("DBI doesn't work when needed", {
  # Initialization fails when wrong driver is provided
  expect_error(connector_dbi(drv = "bad_driver"))
})

# Run same tests for both SQLite and Postgres
for (i in seq_along(specs)) {
  test_that(paste("DBI generics work for", names(specs)[[i]]), {
    cnt <- tryCatch(
      expr = do.call(what = ConnectorDBI$new, args = specs[[i]]),
      error = function(e) {
        skip(paste(names(specs)[[i]], "database not available"))
      }
    )

    cnt$list_content_cnt() |>
      expect_equal(character(0))

    cnt$write_cnt(x, "mtcars") |>
      expect_no_condition()

    cnt$write_cnt(x, "mtcars") |>
      expect_no_condition()

    cnt$list_content_cnt() |>
      expect_equal("mtcars")

    cnt$read_cnt("mtcars") |>
      expect_equal(x)

    cnt$write_cnt(x, "mtcars", overwrite = FALSE) |>
      expect_error()

    cnt$tbl_cnt("mtcars") |>
      dplyr::filter(car == "Mazda RX4") |>
      dplyr::select(car, mpg) |>
      dplyr::collect() |>
      expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

    cnt$conn |>
      DBI::dbGetQuery("SELECT * FROM mtcars") |>
      expect_equal(x)

    cnt$remove_cnt("mtcars") |>
      expect_no_condition()

    cnt$disconnect_cnt() |>
      expect_no_condition()

    cnt$read_cnt("mtcars") |>
      expect_error(regexp = "Invalid(| or closed) connection") # Different messages for postgres and sqlite
  })
}
