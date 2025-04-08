test_that("metadata manipulation in config function works", {
  test_config <- local_create_config()

  # Add metadata fails when needed
  add_metadata(config_path = 1) |>
    expect_error()
  add_metadata(config_path = test_config, key = 1) |>
    expect_error()
  add_metadata(test_config, key = "key", value = 1) |>
    expect_error()

  # Add metadata works
  add_metadata(test_config, key = "key", value = "new_value") |>
    expect_no_condition()

  # Remove metadata fails when needed
  remove_metadata(config_path = 1) |>
    expect_error()
  remove_metadata(config_path = test_config, key = 1) |>
    expect_error()

  # Remove metadata works
  remove_metadata(test_config, key = "key") |>
    expect_no_condition()
})

test_that("metadata manipulation function works", {
  test_config <- local_create_config()

  # Add a new datasource fails when needed
  add_datasource(config_path = 1) |>
    expect_error()
  add_datasource(config_path = test_config, name = 1) |>
    expect_error()
  add_datasource(test_config, key = "new_datasource", backend = 1) |>
    expect_error()

  # Define the backend as a named list
  new_backend <- list(
    type = "connector_fs",
    path = "test"
  )

  # Add a new datasource with the defined backend
  config <- add_datasource(
    config_path = test_config,
    name = "new_datasource",
    backend = new_backend
  ) |>
    expect_no_condition()

  # Remove metadata fails when needed
  remove_datasource(config_path = 1) |>
    expect_error()
  remove_datasource(config_path = test_config, name = 1) |>
    expect_error()

  # Remove a datasource
  config <- remove_datasource(test_config, "new_datasource") |>
    expect_no_condition()
})
