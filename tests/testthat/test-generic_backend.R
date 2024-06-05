test_that("Create a backend for generic backend", {
  only_one <- extract_connections(yaml_content)[[1]]

  my_backend <- only_one %>%
    extract_backends()

  name <- only_one %>%
    extract_con()


  test <- create_backend(yaml_content = yaml_content, backend = my_backend, name = name)

  expect_type(test, "list")
  expect_named(test, "adam_fs")
  connection <- test$adam_fs

  expect_s3_class(connection, c("Connector_fs", "R6"))

  ## Error because of params

  wrong_backend <- my_backend
  wrong_backend$a_random_param <- "a_random_param"

  expect_error(create_backend(yaml_content = yaml_content, backend = wrong_backend, name = name))
})
