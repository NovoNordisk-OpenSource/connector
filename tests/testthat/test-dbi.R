
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
    password = "admin",
    port = 5432,
    host = "localhost"
  )
)

# Run same tests for both SQLite and Postgres

for (i in seq_along(specs)) {

  test_that(paste("DBI generics work for", names(spec)[[i]]), {

    test <- tryCatch(
      expr = do.call(what = connector_dbi$new, args = specs[[i]]),
      error = function(e) {skip(paste(names(spec)[[i]], "database not available"))}
      )

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
      expect_error(regexp = "Invalid(| or closed) connection") # Different messages for postgres and sqlite

  })
}
