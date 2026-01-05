# connectors() - functionality

    Code
      print(x)
    Message
      <connector::connectors/list/S7_object>
        $a <ConnectorFS>
        $b <ConnectorFS>

---

    Code
      print(y)
    Message
      <connector::connectors/list/S7_object>
        $a <ConnectorFS>
        
        Metadata:
        > c: "1"

# datasources()

    Code
      print(expect_no_condition(datasources(list(list(name = "my_source", backend = list(
        type = "my_backend", extra_stuff = 1))))))
    Message
      
      -- Datasources -----------------------------------------------------------------
      
      -- my_source --
      
      * Backend Type: "my_backend"
      * extra_stuff: 1

