test_that("Create a backend for DBI", {
  only_one <- extract_connections(yaml_content)[[2]]

  my_backend <- only_one %>%
    extract_backends()

  name <- only_one %>%
    extract_con()


  test <- create_backend_dbi(yaml_content = yaml_content, backend = my_backend, name = name)

  expect_type(test, "list")
  expect_named(test, "general_dbi")
  connection <- test$general_dbi
  class(connection)
  expect_s3_class(connection, c("Connector_dbi", "R6"))
})
