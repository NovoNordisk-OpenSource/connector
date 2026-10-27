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

# DBI has no directories and no file transfer
connector_contract_tests(
  cases = connector_contract_cases(
    name = "contract",
    expect_read_back = expect_same_rows
  )
)$
  remove_method("create_directory_cnt")$
  remove_method("remove_directory_cnt")$
  remove_method("download_cnt")$
  remove_method("upload_cnt")$
  run(new_connector = \(env) {
    cnt <- connector_dbi(RSQLite::SQLite(), ":memory:")
    withr::defer(disconnect_cnt(cnt), envir = env)
    cnt
  })
