# Connector contract tests

A shared set of `testthat` tests for the behaviour every connector
backend should share, as described in
[`vignette("Consistent-API")`](https://novonordisk-opensource.github.io/connector/articles/Consistent-API.md):
what each method returns, that data read back equals data written, and
that listing reflects writes and removals.

## Usage

``` r
connector_contract_tests(cases = connector_contract_cases())

connector_contract_cases(
  name = "contract.rds",
  data = data.frame(x = c(1, 2, 3), y = c("a", "b", "c")),
  expect_read_back = function(object, expected) {
     testthat::expect_equal(object,
    expected, label = "read_cnt(cnt, name) return value", expected.label =
    "the written data")
 }
)
```

## Arguments

- cases:

  Cases to start the suite with, as a named list of named lists of
  `function(cnt)`, grouped by method. Pass
  `connector_contract_cases(...)` to change the default test data, or
  [`list()`](https://rdrr.io/r/base/list.html) to start empty.

- name:

  Name used to write the test data. Its extension, if any, decides the
  file format. The default `.rds` reads back exactly what was written.

- data:

  Any R object the backend can write under `name` with
  [`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md).

- expect_read_back:

  A `testthat` expectation, `function(object, expected)`, used by the
  [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
  read-back case. `object` is what
  [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
  returned and `expected` is `data`. It must call `testthat::expect_*()`
  functions. The default expects them to be equal, which suits formats
  that keep the object as written, such as `.rds`. Pass your own for
  backends that don't, e.g. a database that returns rows in any order.

## Value

`connector_contract_tests()`: a
[ConnectorContract](https://novonordisk-opensource.github.io/connector/reference/ConnectorContract.md)
object.

`connector_contract_cases()`: a named list of named lists of functions.

## Details

`connector_contract_tests()` returns a
[ConnectorContract](https://novonordisk-opensource.github.io/connector/reference/ConnectorContract.md)
suite, by default with the cases from `connector_contract_cases()`: a
named list with one entry per connector method, each a named list of
cases. A case is a `function(cnt)` that runs expectations against a new,
empty connector. Print the suite to see what will run, and change it
before running it:

- drop a method the backend does not support:
  `suite$remove_method("create_directory_cnt")`

- drop a case:
  `suite$remove_case("read_cnt", "errors on missing content")`

- add a case: `suite$add_case("read_cnt", "<case>", function(cnt) ...)`

The builder methods change the suite in place and return it, so they
chain. Use `suite$clone()` to change a copy instead.

Case names describe the expected behaviour of their method, and are
unique within it. The same name can describe several methods, e.g.
`"returns the connector"`. `suite$run()` runs every case as its own
[`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html),
named `"connector contract: <method>() <case>"`. Call it from a test
file in a package that extends connector.

## Debugging a failing case

Failures name the case and say what was expected, but point at the line
that calls `suite$run()`, not at the case itself. A case is a plain
function, so you can print its code and step through it:

    case <- connector_contract_tests()$get_case(
      "remove_cnt",
      "returns the connector and removes content"
    )
    case                                     # prints the case's code
    cnt <- new_connector(env = globalenv())  # your connector function
    debugonce(case)
    case(cnt)

## Examples

``` r
connector_contract_tests()
#> <ConnectorContract> with 10 cases
#> `write_cnt()`
#> • returns the connector
#> `read_cnt()`
#> • returns the written data
#> • errors on missing content
#> `list_content_cnt()`
#> • lists written content
#> `remove_cnt()`
#> • returns the connector and removes content
#> `create_directory_cnt()`
#> • with open = FALSE returns the connector
#> • with open = TRUE returns a new connector
#> `remove_directory_cnt()`
#> • returns the connector and removes it
#> `download_cnt()`
#> • returns the connector and creates a file
#> `upload_cnt()`
#> • returns the connector and adds content

# tests/testthat/test-contract.R
connector_contract_tests()$
  remove_method("download_cnt")$
  remove_method("upload_cnt")$
  run(new_connector = \(env) {
    connector_fs(withr::local_tempdir(.local_envir = env))
  })
#> ✔ | F W  S  OK | Context
#> 
#> ⠏ |          0 | connector contract                                             
#> ⠋ |          1 | connector contract                                             
#> ⠴ |          6 | connector contract                                             
#> ✔ |         13 | connector contract
#> 
#> ══ Results ═════════════════════════════════════════════════════════════════════
#> [ FAIL 0 | WARN 0 | SKIP 0 | PASS 13 ]
```
