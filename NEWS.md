
# connector dev

- Connectors constructor builds the datasources attribute
- Create a new class for nested connectors objects, "nested_connectors"
- Add README and vignette on how to extend connector


# connector 0.0.4 (2024-12-03)

### Migration:
-   Migration to public github

### Features:
-   Update of `create_directory_cnt()`
-   Added metadata as a parameter in `connect()`
-   More comprehensive testing
-   Better integration with [whirl](https://github.com/NovoNordisk-OpenSource/whirl) through [connector.logger](https://github.com/NovoNordisk-OpenSource/connector.logger)

### Other:
-   Reducing the number of dependencies.
-   Better messages

# connector 0.0.3 (2024-09-25)

### Breaking Changes:
-   rename function from `*_cnt` to `cnt_`

### Features:
-   Nested connectors objects
-   Use active bindings
-   User guide added


# connector 0.0.2

-   Added `connectors` super class

# connector 0.0.1

-   Initial version
