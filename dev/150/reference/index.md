# Package index

## Use connector

- [`connect()`](https://novonordisk-opensource.github.io/connector/reference/connect.md)
  : Connect to datasources specified in a config file
- [`use_connector()`](https://novonordisk-opensource.github.io/connector/reference/use_connector.md)
  : Use connector
- [`connector-options`](https://novonordisk-opensource.github.io/connector/reference/connector-options.md)
  : Options for connector

## Connectors

- [`connectors()`](https://novonordisk-opensource.github.io/connector/reference/connectors.md)
  : Collection of connector objects

- [`Connector`](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  [`connector`](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
  : General connector object

- [`connector_fs()`](https://novonordisk-opensource.github.io/connector/reference/connector_fs.md)
  :

  Create `fs` connector

- [`ConnectorFS`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.md)
  : Connector for file storage

- [`connector_dbi()`](https://novonordisk-opensource.github.io/connector/reference/connector_dbi.md)
  :

  Create `dbi` connector

- [`ConnectorDBI`](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.md)
  : Connector for DBI databases

- [`nested_connectors()`](https://novonordisk-opensource.github.io/connector/reference/nested_connectors.md)
  : Create a nested connectors object

## Connector functions

- [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
  : Read content from the connector
- [`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md)
  : Write content to the connector
- [`remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.md)
  : Remove content from the connector
- [`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md)
  : List available content from the connector
- [`create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/create_directory_cnt.md)
  : Create a directory
- [`disconnect_cnt()`](https://novonordisk-opensource.github.io/connector/reference/disconnect_cnt.md)
  : Disconnect (close) the connection of the connector
- [`download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_cnt.md)
  : Download content from the connector
- [`download_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_directory_cnt.md)
  : Download a directory
- [`remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.md)
  : Remove a directory
- [`tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.md)
  : Use dplyr verbs to interact with the remote database table
- [`upload_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_cnt.md)
  : Upload content to the connector
- [`upload_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_directory_cnt.md)
  : Upload a directory

## Read and write files

- [`read_file()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md)
  [`read_ext()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md)
  : Read files based on the extension
- [`write_file()`](https://novonordisk-opensource.github.io/connector/reference/write_file.md)
  [`write_ext()`](https://novonordisk-opensource.github.io/connector/reference/write_file.md)
  : Write files based on the extension

## Logs

- [`ConnectorLogger`](https://novonordisk-opensource.github.io/connector/reference/ConnectorLogger.md)
  [`print(`*`<ConnectorLogger>`*`)`](https://novonordisk-opensource.github.io/connector/reference/ConnectorLogger.md)
  : Create a New Connector Logger
- [`add_logs()`](https://novonordisk-opensource.github.io/connector/reference/add_logs.md)
  : Add Logging Capability to Connections
- [`log_read_connector()`](https://novonordisk-opensource.github.io/connector/reference/log-functions.md)
  [`log_write_connector()`](https://novonordisk-opensource.github.io/connector/reference/log-functions.md)
  [`log_remove_connector()`](https://novonordisk-opensource.github.io/connector/reference/log-functions.md)
  [`log_list_content_connector()`](https://novonordisk-opensource.github.io/connector/reference/log-functions.md)
  : Connector Logging Functions

## Utils

- [`list_datasources()`](https://novonordisk-opensource.github.io/connector/reference/list_datasources.md)
  : Extract data sources from connectors
- [`extract_metadata()`](https://novonordisk-opensource.github.io/connector/reference/extract_metadata.md)
  : Extract metadata from connectors
- [`validate_resource()`](https://novonordisk-opensource.github.io/connector/reference/resource-validation.md)
  [`check_resource()`](https://novonordisk-opensource.github.io/connector/reference/resource-validation.md)
  : Resource Validation System for Connector Objects
- [`write_datasources()`](https://novonordisk-opensource.github.io/connector/reference/write_datasources.md)
  : Write datasources attribute into a config file
- [`add_datasource()`](https://novonordisk-opensource.github.io/connector/reference/add_datasource.md)
  : Add a new datasource to a YAML configuration file
- [`remove_datasource()`](https://novonordisk-opensource.github.io/connector/reference/remove_datasource.md)
  : Remove a datasource from a YAML configuration file
- [`add_metadata()`](https://novonordisk-opensource.github.io/connector/reference/add_metadata.md)
  : Add metadata to a YAML configuration file
- [`remove_metadata()`](https://novonordisk-opensource.github.io/connector/reference/remove_metadata.md)
  : Remove metadata from a YAML configuration file
