library(connector)

db <- connect("_connector.yml", logging = TRUE)
### FS
db$folder |>
  list_content_cnt()

cars <- mtcars |>
  tibble::as_tibble(rownames = "car")

db$folder |>
  write_cnt(x = cars, name = "cars.parquet")

db$folder |>
  list_content_cnt()

db$folder |>
  read_cnt(name = "cars.parquet")

### DB

# Initially no tables exists
db$database |>
  list_content_cnt()
#> character(0)

# Write cars to the database as a table
db$database |>
  write_cnt(x = cars, name = "cars")

# Now the cara table exists
db$database |>
  list_content_cnt()
#> [1] "cars"

# And we can read it back in
db$database |>
  read_cnt(name = "cars") |>
  dplyr::as_tibble()
