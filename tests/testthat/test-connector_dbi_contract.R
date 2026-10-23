# A table has no row order, so compare rows regardless of order
expect_same_rows <- function(object, expected) {
  sort_rows <- function(x) {
    x <- as.data.frame(x)
    x <- x[do.call(order, unname(x)), , drop = FALSE]
    rownames(x) <- NULL
    x
  }
  testthat::expect_equal(sort_rows(object), sort_rows(expected))
}

dbi_tests <- connector_contract_tests(
  name = "contract",
  expect_read_back = expect_same_rows
)
# DBI has no directories and no file transfer
dbi_tests[c(
  "create_directory_cnt",
  "remove_directory_cnt",
  "download_cnt",
  "upload_cnt"
)] <- NULL

run_connector_contract_tests(
  dbi_tests,
  new_connector = \(env) {
    cnt <- connector_dbi(RSQLite::SQLite(), ":memory:")
    withr::defer(disconnect_cnt(cnt), envir = env)
    cnt
  }
)
