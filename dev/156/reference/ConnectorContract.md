# Connector contract test suite

A suite of contract cases grouped by connector method. Create one with
[`connector_contract_tests()`](https://novonordisk-opensource.github.io/connector/reference/connector_contract_tests.md),
which describes the default cases and how to run them.

## Methods

### Public methods

- [`ConnectorContract$new()`](#method-ConnectorContract-new)

- [`ConnectorContract$get_case()`](#method-ConnectorContract-get_case)

- [`ConnectorContract$add_case()`](#method-ConnectorContract-add_case)

- [`ConnectorContract$remove_case()`](#method-ConnectorContract-remove_case)

- [`ConnectorContract$remove_method()`](#method-ConnectorContract-remove_method)

- [`ConnectorContract$run()`](#method-ConnectorContract-run)

- [`ConnectorContract$print()`](#method-ConnectorContract-print)

- [`ConnectorContract$clone()`](#method-ConnectorContract-clone)

------------------------------------------------------------------------

### Method `new()`

Create a suite. Prefer
[`connector_contract_tests()`](https://novonordisk-opensource.github.io/connector/reference/connector_contract_tests.md).

#### Usage

    ConnectorContract$new(cases = list())

#### Arguments

- `cases`:

  Named list of named lists of `function(cnt)`, grouped by method.

------------------------------------------------------------------------

### Method `get_case()`

Get one case, e.g. to debug it.

#### Usage

    ConnectorContract$get_case(method, name)

#### Arguments

- `method`:

  Name of the connector method.

- `name`:

  Case name.

#### Returns

The case, a `function(cnt)`.

------------------------------------------------------------------------

### Method `add_case()`

Add a case under a method.

#### Usage

    ConnectorContract$add_case(method, name, case)

#### Arguments

- `method`:

  Name of the connector method the case tests.

- `name`:

  Case name, describing the expected behaviour. Unique within the
  method.

- `case`:

  A `function(cnt)` running expectations against a new, empty connector.

#### Returns

The suite, invisibly.

------------------------------------------------------------------------

### Method `remove_case()`

Remove one case.

#### Usage

    ConnectorContract$remove_case(method, name)

#### Arguments

- `method`:

  Name of the connector method.

- `name`:

  Case name.

#### Returns

The suite, invisibly.

------------------------------------------------------------------------

### Method `remove_method()`

Remove all of a method's cases, e.g. for a method the backend does not
support.

#### Usage

    ConnectorContract$remove_method(method)

#### Arguments

- `method`:

  Name of the connector method.

#### Returns

The suite, invisibly.

------------------------------------------------------------------------

### Method `run()`

Run every case as its own
[`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html),
named `"connector contract: <method>() <case>"`.

#### Usage

    ConnectorContract$run(
      new_connector,
      reporter = if (testthat::is_testing()) {
         NULL
     } else {

        testthat::ProgressReporter$new(show_praise = FALSE)
     }
    )

#### Arguments

- `new_connector`:

  `function(env)` returning a new, empty connector. Any cleanup must be
  tied to `env`, e.g. with `withr::local_tempdir(.local_envir = env)`,
  so it runs when each test ends.

- `reporter`:

  `NULL` to report to the active `testthat` reporter, as in a package's
  test files. Or a
  [testthat::Reporter](https://testthat.r-lib.org/reference/Reporter.html)
  to report the cases on their own. Defaults to `NULL` inside a
  `testthat` run and to a progress reporter that prints a summary
  outside one, e.g. in the console.

#### Returns

The suite, invisibly.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the cases grouped by method.

#### Usage

    ConnectorContract$print(...)

#### Arguments

- `...`:

  Not used.

#### Returns

The suite, invisibly.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ConnectorContract$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
