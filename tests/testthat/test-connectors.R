test_that("connectors() - correct error handling", {
  connectors() |>
    expect_error("At least one Connector must be supplied")

  connectors(
    a = connector_fs(withr::local_tempdir()),
    connector_fs(withr::local_tempdir())
  ) |>
    expect_error("All elements must be named")

  connectors(
    a = connector_fs(withr::local_tempdir()),
    b = mtcars
  ) |>
    expect_error("All elements must be a Connector object")

  connectors(
    a = connector_fs(withr::local_tempdir()),
    connector_fs(withr::local_tempdir())
  ) |>
    expect_error("All elements must be named")

  connectors(
    a = connector_fs(withr::local_tempdir()),
    .datasources = list(
      list(type = "connector_fs")
    )
  ) |>
    expect_error()

  connectors(
    a = connector_fs(withr::local_tempdir()),
    b = connector_fs(withr::local_tempdir()),
    .datasources = list(
      list(name = "a", backend = list(type = "b"))
    )
  ) |>
    expect_error("Each 'Connector' must have a corresponding datasource")

  connectors(
    a = connector_fs(withr::local_tempdir()),
    b = connector_fs(withr::local_tempdir())
  ) |>
    expect_no_error()
})

test_that("connectors() - functionality", {
  x <- connectors(
    a = connector_fs(withr::local_tempdir()),
    b = connector_fs(withr::local_tempdir())
  )

  expect_error({
    x@metadata <- list(a = 1)
  })

  expect_error({
    x@datasources <- list(b = 1)
  })

  print(x) |>
    expect_snapshot()

  x@metadata |>
    expect_type("list") |>
    expect_length(0)

  x@datasources |>
    expect_s7_class(datasources) |>
    expect_type("list") |>
    expect_length(2) |>
    purrr::map(list("backend", "type")) |>
    unlist() |>
    expect_equal(
      c(
        "connector::connector_fs",
        "connector::connector_fs"
      )
    )

  y <- connectors(
    a = connector_fs(withr::local_tempdir()),
    .metadata = list(c = 1)
  )

  print(y) |>
    expect_snapshot()

  y@metadata |>
    expect_type("list") |>
    expect_equal(list(c = 1))
})

test_that("is_connectors()", {
  connectors(
    a = connector_fs(withr::local_tempdir())
  ) |>
    is_connectors() |>
    expect_true()

  connector_fs(withr::local_tempdir()) |>
    is_connectors() |>
    expect_false()
})

test_that("datasources()", {
  datasources(list()) |>
    expect_no_condition()

  datasources(list(a = 1)) |>
    expect_error(
      "All elements must be not be named"
    )

  datasources(list(list(name = "my_source"))) |>
    expect_error(
      "Each datasource must have \\(only\\) 'name' and 'backend' specified"
    )

  datasources(list(list(name = "my_source", backend = list(id = 1)))) |>
    expect_error(
      "Each datasource must have backend type specified"
    )

  datasources(
    list(
      list(
        name = "my_source",
        backend = list(type = "my_backend", extra_stuff = 1)
      )
    )
  ) |>
    expect_no_condition() |>
    print() |>
    expect_snapshot()
})
