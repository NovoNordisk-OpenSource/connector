usethis::use_build_ignore("dev")


### Add adam dataset to the adam folder
# remotes::install_github("pharmaverse/pharmaverseadam") # nolint
pkgload::load_all()

adam_dfs <- data(package = "pharmaverseadam")[["results"]][, "Item"] |>
  intersect(c("adsl", "adlb"))

sdtm_dfs <- data(package = "pharmaversesdtm")[["results"]][, "Item"] |>
  intersect(c("dm", "lb"))

adam_dir <- system.file("demo_trial", "adam", package = "connector")
sdtm_dir <- system.file("demo_trial", "sdtm", package = "connector")

purrr::walk(
  adam_dfs,
  ~ {
    df <- getExportedValue(ns = "pharmaverseadam", .x) |> head(100)
    readr::write_csv(x = df, file = file.path(adam_dir, paste0(.x, ".csv")))
    readr::write_rds(x = df, file = file.path(adam_dir, paste0(.x, ".rds")))
    arrow::write_parquet(x = df, sink = file.path(adam_dir, paste0(.x, ".parquet")))
  }
)

purrr::walk(
  sdtm_dfs,
  ~ {
    df <- getExportedValue(ns = "pharmaversesdtm", .x) |> head(100)
    readr::write_csv(x = df, file = file.path(sdtm_dir, paste0(.x, ".csv")))
    readr::write_rds(x = df, file = file.path(sdtm_dir, paste0(.x, ".rds")))
    arrow::write_parquet(x = df, sink = file.path(sdtm_dir, paste0(.x, ".parquet")))
  }
)

## Manage deps
attachment::att_amend_desc()
usethis::use_package("dbplyr", type = "Suggests")
usethis::use_package("RPostgres", type = "Suggests")
usethis::use_package("RSQLite", type = "Suggests")
usethis::use_package("yaml", type = "Suggests")

## Testthat

usethis::use_test("fs_read")
usethis::use_test("fs_write")
usethis::use_test("utils_yaml")
usethis::use_test("utils_files")
usethis::use_test("dbi_backend_tools")
usethis::use_test("fs_backend_tools")
usethis::use_test("generic_backend")
