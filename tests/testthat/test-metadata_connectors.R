test_that("extract_metadata works with metadata present", {
  # Create a mock connectors object with metadata
  mock_connectors <- structure(
    list(adam = "dummy_connector"),
    class = "connectors"
  )
  attr(mock_connectors, "metadata") <- list(
    study = "demo_study",
    version = "1.0",
    author = "test_user"
  )

  # Test extracting all metadata
  result_all <- extract_metadata(mock_connectors)
  expected_all <- list(
    study = "demo_study",
    version = "1.0",
    author = "test_user"
  )
  expect_equal(result_all, expected_all)

  # Test extracting specific metadata field
  result_study <- extract_metadata(mock_connectors, name = "study")
  expect_equal(result_study, "demo_study")

  # Test extracting non-existent field
  result_nonexistent <- extract_metadata(mock_connectors, name = "nonexistent")
  expect_null(result_nonexistent)

  extract_metadata(mock_connectors, name = 123) |>
    expect_error("Assertion on 'name' failed")
})

test_that("extract_metadata works with NULL metadata", {
  # Create a mock connectors object without metadata
  mock_connectors <- structure(
    list(adam = "dummy_connector"),
    class = "connectors"
  )
  attr(mock_connectors, "metadata") <- NULL

  # Test extracting all metadata (should return NULL)
  result_all <- extract_metadata(mock_connectors)
  expect_null(result_all)

  # Test extracting specific field from NULL metadata (should return NULL)
  result_specific <- extract_metadata(mock_connectors, name = "study")
  expect_null(result_specific)
})

test_that("extract_metadata works with connect function", {
  # Create connectors using connect function with real config
  cnts <- connect(yaml_file)

  # Test extracting all metadata
  result_all <- extract_metadata(cnts)
  expect_type(result_all, "list")
  expect_true("trial" %in% names(result_all))
  expect_equal(result_all$trial, "demo_trial")

  # Test extracting specific metadata field
  result_trial <- extract_metadata(cnts, name = "trial")
  expect_equal(result_trial, "demo_trial")

  # Test extracting another specific field
  result_extra <- extract_metadata(cnts, name = "extra_class")
  expect_equal(result_extra, "test2")

  # Test extracting non-existent field
  result_nonexistent <- extract_metadata(cnts, name = "nonexistent")
  expect_null(result_nonexistent)

  # Error with .md as a data source
  error_confg <- yaml_content_raw
  error_confg$datasources[[1]]$name <- ".md"

  expect_error(
    connect(
      error_confg
    ),
    "'.md' is a reserved name. It cannot be used as a name for a data source."
  )
})

cli::test_that_cli("print metadata infos", {
  temp_dir <- withr::local_tempdir("connector_test_md")

  withr::with_tempdir(tmpdir = temp_dir, {
    config <- list(
      metadata = list(
        extra_class = "test2"
      ),
      datasources = list(
        list(
          name = "test",
          backend = list(
            type = "connector_fs",
            path = ".",
            extra_class = "{metadata.extra_class}"
          )
        )
      )
    )

    cnts <- connect(
      config = config
    )
    expect_snapshot(cnts)
  })
})
