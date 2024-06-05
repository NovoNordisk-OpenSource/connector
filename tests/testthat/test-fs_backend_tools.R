test_that("Create a backend for FS", {
  only_one <- extract_connections(yaml_content)[[1]]

  my_backend <- only_one %>%
    extract_backends()

  name <- only_one %>%
    extract_con()


  test <- create_backend_fs(yaml_content = yaml_content, backend = my_backend, name = name)

  expect_type(test, "list")
  expect_named(test, "adam_fs")
  connection <- test$adam_fs
  expect_s3_class(connection, c("Connector_fs", "R6"))

  ## Extra class
  expect_s3_class(connection, "test2")
})

test_that("Tools for backend creation", {
  example_with_metadata <- "{metadata.trial}/adam"

  expect_true(
    custom_path_or_not(example_with_metadata)
  )

  infos <- extract_info_from_metadata(yaml_content["metadata"], example_with_metadata)

  expect_equal(
    infos,
    c("metadata.trial" = "demo_trial")
  )

  expect_error(
    extract_info_from_metadata(
      yaml_content["metadata"],
      "{connections[[1]].backend.extra_class}"
    )
  )

  expect_equal(
    extract_custom_path(yaml_content, example_with_metadata),
    "demo_trial/adam"
  )

  example_without_metadata <- "adam"

  expect_false(
    custom_path_or_not(example_without_metadata)
  )

  expect_equal(
    extract_custom_path(yaml_content, example_without_metadata),
    "adam"
  )
})
