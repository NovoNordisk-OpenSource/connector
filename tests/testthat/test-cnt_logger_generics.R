# Helper function to create logged FS connector with test data

create_logged_fs_connector <- function(temp_dir) {
  temp_file <- file.path(temp_dir, "test_data.csv")
  write.csv(mtcars, temp_file, row.names = FALSE)

  logged_conn <- add_logs(connectors(test = connector_fs(path = temp_dir)))$test
  list(
    connector = logged_conn,
    temp_dir = temp_dir,
    temp_file = temp_file
  )
}

# Helper function to test method with logging
test_method_with_logging <- function(
  method_call,
  expected_log_pattern,
  expected_result_check = NULL
) {
  captured <- capture_output_lines(method_call)
  result <- method_call

  # Check logging output
  expect_true(any(grepl(expected_log_pattern, captured)))

  # Check result if validation function provided
  if (!is.null(expected_result_check)) {
    expected_result_check(result)
  }

  result
}

logger <- ConnectorLogger

test_that("ConnectorLogger is created correctly", {
  expect_s3_class(logger, "ConnectorLogger")
  expect_equal(length(logger), 0)
})

test_that("print.ConnectorLogger works correctly", {
  expect_output(print(logger))
})

test_that("ConnectorLogger read methods work with real FS connector", {
  temp_dir <- withr::local_tempdir("connector_logger_test")
  setup <- create_logged_fs_connector(temp_dir)

  # Test read_cnt.ConnectorLogger
  result <- test_method_with_logging(
    read_cnt(setup$connector, "test_data.csv"),
    "test_data.csv",
    function(r) {
      expect_s3_class(r, "data.frame")
      expect_equal(nrow(r), 32)
    }
  )

  # Test tbl_cnt.ConnectorLogger (should work same as read_cnt)
  tbl_result <- test_method_with_logging(
    tbl_cnt(setup$connector, "test_data.csv"),
    "test_data.csv",
    function(r) expect_s3_class(r, "data.frame")
  )
})

test_that("ConnectorLogger write and remove methods work with real FS connector", {
  temp_dir <- withr::local_tempdir("connector_logger_test")
  setup <- create_logged_fs_connector(temp_dir)

  # Test write_cnt.ConnectorLogger
  test_method_with_logging(
    write_cnt(setup$connector, iris, "test_iris.csv", overwrite = TRUE),
    "test_iris.csv"
  )
  expect_true(file.exists(file.path(setup$temp_dir, "test_iris.csv")))

  # Test remove_cnt.ConnectorLogger
  test_method_with_logging(
    remove_cnt(setup$connector, "test_iris.csv"),
    "test_iris.csv"
  )
  expect_false(file.exists(file.path(setup$temp_dir, "test_iris.csv")))
})

test_that("ConnectorLogger list_content method works with real FS connector", {
  temp_dir <- withr::local_tempdir("connector_logger_test")
  setup <- create_logged_fs_connector(temp_dir)

  # Test list_content_cnt.ConnectorLogger
  contents <- test_method_with_logging(
    list_content_cnt(setup$connector),
    "\\.",
    function(r) grepl("test_data.csv", r)
  )
})

test_that("ConnectorLogger upload and download methods work with real FS connector", {
  temp_dir <- withr::local_tempdir("connector_logger_test")

  setup <- create_logged_fs_connector(temp_dir)

  test_file <- file.path(setup$temp_dir, "upload_test.txt")
  writeLines("test content", test_file)

  uploaded_file <- file.path(setup$temp_dir, "uploaded_file.txt")
  download_path <- file.path(setup$temp_dir, "downloaded_file.txt")

  # Test upload_cnt.ConnectorLogger
  test_method_with_logging(
    upload_cnt(setup$connector, test_file, dest = "uploaded_file.txt"),
    "uploaded_file.txt"
  )
  expect_true(file.exists(uploaded_file))

  # Test download_cnt.ConnectorLogger
  result <- test_method_with_logging(
    download_cnt(setup$connector, "uploaded_file.txt", dest = download_path),
    "uploaded_file.txt"
  )
  expect_true(file.exists(download_path))
})
