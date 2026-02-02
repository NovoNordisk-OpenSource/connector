test_that("extract_metadata works with metadata present", {
  # Create a connectors object with metadata
  x <- connectors(
    adam = connector_fs(path = tempdir()),
    .metadata = list(
      study = "demo_study",
      version = "1.0",
      author = "test_user"
    )
  )

  # Test extracting all metadata
  result_all <- extract_metadata(x)
  expected_all <- list(
    study = "demo_study",
    version = "1.0",
    author = "test_user"
  )
  expect_equal(result_all, expected_all)

  # Test extracting specific metadata field
  extract_metadata(x, name = "study") |>
    expect_equal("demo_study")

  # Test extracting non-existent field
  extract_metadata(x, name = "nonexistent") |>
    expect_null()

  extract_metadata(x, name = 123) |>
    expect_error("Assertion on 'name' failed")
})

test_that("extract_metadata works with no metadata", {
  # Create a connectors object without metadata
  x <- connectors(
    adam = connector_fs(path = tempdir())
  )

  # Test extracting all metadata (should return empty list)
  extract_metadata(x) |>
    expect_type("list") |>
    expect_length(0)

  # Test extracting specific field from NULL metadata (should return NULL)
  extract_metadata(x, name = "study") |>
    expect_null()
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

  # Error with .metadata as a data source
  error_confg <- yaml_content_raw
  error_confg$datasources[[1]]$name <- ".metadata"

  expect_error(
    connect(
      error_confg
    ),
    "'.metadata' and '.datasources' are reserved names. They cannot be used as a name for a data source."
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
