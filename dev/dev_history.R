usethis::use_build_ignore("dev")


### Add adam dataset to the adam folder
# remotes::install_github("pharmaverse/pharmaverseadam")
pkgload::load_all()

dfs <- data(package = "pharmaverseadam")[["results"]][,"Item"]


adam_dir <- system.file("trials","id_numtrial","adam", package = "connector" )

purrr::walk(
  dfs,
  ~ {
    readr::write_csv(x = getExportedValue(ns = "pharmaverseadam", .x), file = file.path(adam_dir, paste0(.x, ".csv")))
  }
)
