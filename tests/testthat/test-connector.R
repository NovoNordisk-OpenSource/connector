test_that("can create Connector object", {
  connector_obj <- connectors(
    test = "test"
  )

  expect_s3_class(connector_obj, "connectors")

  expect_snapshot(connector_obj)
})
