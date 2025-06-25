test_that("can create Connector object", {
  connector_obj <- connectors(
    test = ConnectorFS$new(path = tempdir())
  )

  expect_s3_class(connector_obj, "connectors")

  expect_snapshot(connector_obj)

  expect_type(print_cnt, "closure")

  #####
  # Datasources
  #####

  # errors datasources:
  expect_error(
    connectors(
      datasources = "test"
    )
  )

  expect_error(datasources(NULL))
})


cli::test_that_cli("Test connector creation", {
  connector_obj <- connectors(
    test = ConnectorFS$new(path = tempdir())
  )
  expect_snapshot_out(print(connector_obj$test))
})
