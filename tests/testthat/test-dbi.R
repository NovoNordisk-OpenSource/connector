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
    password = Sys.getenv("POSTGRES_PW"), # Stored in GH actions
    port = 5432,
    host = "localhost"
  )
)

# Run same tests for both SQLite and Postgres

for (i in seq_along(specs)) {
  test_that(paste("DBI generics work for", names(specs)[[i]]), {
    test <- tryCatch(
      expr = do.call(what = connector_dbi$new, args = specs[[i]]),
      error = function(e) {
        skip(paste(names(specs)[[i]], "database not available"))
      }
    )

    test$cnt_list_content() |>
      expect_equal(character(0))

    test$cnt_write(x, "mtcars") |>
      expect_true()

    test$cnt_write(x, "mtcars") |>
      expect_error()

    test$cnt_list_content() |>
      expect_equal("mtcars")

    test$cnt_read("mtcars") |>
      expect_equal(x)

    test$cnt_write(x, "mtcars", overwrite = TRUE) |>
      expect_true()

    test$cnt_tbl("mtcars") |>
      dplyr::filter(car == "Mazda RX4") |>
      dplyr::select(car, mpg) |>
      dplyr::collect() |>
      expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

    test$conn |>
      DBI::dbGetQuery("SELECT * FROM mtcars") |>
      expect_equal(x)

    test$cnt_remove("mtcars") |>
      expect_true()

    test$cnt_disconnect() |>
      expect_true()

    test$cnt_read("mtcars") |>
      expect_error(regexp = "Invalid(| or closed) connection") # Different messages for postgres and sqlite
  })
}
