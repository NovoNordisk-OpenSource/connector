# print() lists cases grouped by method

    Code
      print(suite)
    Message
      <ConnectorContract> with 3 cases
      `method_a()`
      * passes
      * fails
      `method_b()`
      * passes

# print() drops a method once its last case is removed

    Code
      print(suite)
    Message
      <ConnectorContract> with 2 cases
      `method_a()`
      * passes
      * fails

