test_that("Extract element from yaml content", {
  yaml_file <- system.file("config", "default_config.yml", package = "connector")
  yaml_content <- yaml::read_yaml(yaml_file, eval.expr = TRUE)

  one_element <- extract_element(yaml_content, "metadata")

  expect_type(one_element, "list")
  expect_named(one_element, c("trial", "root_path", "extra_class"))

  metadata <- extract_metadata(yaml_content)
  expect_type(metadata, "list")
  expect_named(metadata, c("trial", "root_path", "extra_class"))


  connections <- extract_connections(yaml_content)
  expect_type(connections, "list")
  expect_equal(length(connections), 2)
  purrr::walk(connections, ~ expect_named(.x, c("con", "backend")))

  one_connection <- connections[[1]]
  backend <- extract_backends(one_connection)
  expect_type(backend, "list")
  expect_named(backend, c("type", "path", "extra_class"))

  con <- extract_con(one_connection)
  expect_equal(con, "adam_fs")


  datasources <- extract_datasources(yaml_content)
  expect_equal(length(datasources), 2)
  purrr::walk(datasources, ~ expect_named(.x, c("name", "con")))
})
