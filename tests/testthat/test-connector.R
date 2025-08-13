test_that("can create Connector object", {
  temp_dir <- withr::local_tempdir("connector_test")

  withr::with_tempdir(tmpdir = temp_dir, {
    connector_obj <- connectors(
      test = ConnectorFS$new(path = ".")
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

    expect_error(list_datasources(NULL))
  })
})


cli::test_that_cli("Test connector creation", {
  temp_dir <- withr::local_tempdir("connector_test")

  withr::with_tempdir(tmpdir = temp_dir, {
    connector_obj <- connectors(
      test = ConnectorFS$new(path = ".")
    )
    expect_snapshot_out(print(connector_obj$test))
  })
})

cli::test_that_cli("can create Connector object", {
  temp_dir <- withr::local_tempdir("connector_test")

  withr::with_tempdir(tmpdir = temp_dir, {
    test <- ConnectorFS$new(path = ".")

    connector_obj <- connectors(
      test = test,
      test_2 = base::as.data.frame(x = iris)
    )

    expect_snapshot_out(print(list_datasources(connector_obj)))
  })
})

test_that("validate_resource works correctly", {
  temp_dir <- withr::local_tempdir("validate_test")

  withr::with_tempdir(tmpdir = temp_dir, {
    # Test with valid directory
    expect_no_error(ConnectorFS$new(path = "."))

    # Test with invalid directory
    expect_error(
      ConnectorFS$new(path = "nonexistent_dir"),
      "does not exist"
    )
  })
})
