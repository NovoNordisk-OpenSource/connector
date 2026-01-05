# Connector for file storage

The ConnectorFS class is a file storage connector for accessing and
manipulating files any file storage solution. The default implementation
includes methods for files stored on local or network drives.

## Details

We recommend using the wrapper function
[`connector_fs()`](https://novonordisk-opensource.github.io/connector/reference/connector_fs.md)
to simplify the process of creating an object of ConnectorFS class. It
provides a more intuitive and user-friendly approach to initialize the
ConnectorFS class and its associated functionalities.

## Super class

[`connector::Connector`](https://novonordisk-opensource.github.io/connector/reference/Connector.md)
-\> `ConnectorFS`

## Active bindings

- `path`:

  [character](https://rdrr.io/r/base/character.html) Path to the file
  storage

## Methods

### Public methods

- [`ConnectorFS$new()`](#method-ConnectorFS-new)

- [`ConnectorFS$download_cnt()`](#method-ConnectorFS-download_cnt)

- [`ConnectorFS$upload_cnt()`](#method-ConnectorFS-upload_cnt)

- [`ConnectorFS$create_directory_cnt()`](#method-ConnectorFS-create_directory_cnt)

- [`ConnectorFS$remove_directory_cnt()`](#method-ConnectorFS-remove_directory_cnt)

- [`ConnectorFS$upload_directory_cnt()`](#method-ConnectorFS-upload_directory_cnt)

- [`ConnectorFS$download_directory_cnt()`](#method-ConnectorFS-download_directory_cnt)

- [`ConnectorFS$tbl_cnt()`](#method-ConnectorFS-tbl_cnt)

- [`ConnectorFS$clone()`](#method-ConnectorFS-clone)

Inherited methods

- [`connector::Connector$list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-list_content_cnt)
- [`connector::Connector$print()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-print)
- [`connector::Connector$read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-read_cnt)
- [`connector::Connector$remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-remove_cnt)
- [`connector::Connector$write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-write_cnt)

------------------------------------------------------------------------

### Method `new()`

Initializes the connector for file storage.

#### Usage

    ConnectorFS$new(path, extra_class = NULL)

#### Arguments

- `path`:

  [character](https://rdrr.io/r/base/character.html) Path to the file
  storage.

- `extra_class`:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector.

------------------------------------------------------------------------

### Method [`download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_cnt.md)

Download content from the file storage. See also
[download_cnt](https://novonordisk-opensource.github.io/connector/reference/download_cnt.md).

#### Usage

    ConnectorFS$download_cnt(src, dest = basename(src), ...)

#### Arguments

- `src`:

  [character](https://rdrr.io/r/base/character.html) The name of the
  file to download from the connector

- `dest`:

  [character](https://rdrr.io/r/base/character.html) Path to the file to
  download to

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.

------------------------------------------------------------------------

### Method [`upload_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_cnt.md)

Upload a file to the file storage. See also
[upload_cnt](https://novonordisk-opensource.github.io/connector/reference/upload_cnt.md).

#### Usage

    ConnectorFS$upload_cnt(src, dest = basename(src), ...)

#### Arguments

- `src`:

  [character](https://rdrr.io/r/base/character.html) Path to the file to
  upload

- `dest`:

  [character](https://rdrr.io/r/base/character.html) The name of the
  file to create

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

[invisible](https://rdrr.io/r/base/invisible.html) self.

------------------------------------------------------------------------

### Method [`create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/create_directory_cnt.md)

Create a directory in the file storage. See also
[create_directory_cnt](https://novonordisk-opensource.github.io/connector/reference/create_directory_cnt.md).

#### Usage

    ConnectorFS$create_directory_cnt(name, ...)

#### Arguments

- `name`:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to create

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

ConnectorFS object of a newly created directory

------------------------------------------------------------------------

### Method [`remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.md)

Remove a directory from the file storage. See also
[remove_directory_cnt](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.md).

#### Usage

    ConnectorFS$remove_directory_cnt(name, ...)

#### Arguments

- `name`:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to remove

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

[invisible](https://rdrr.io/r/base/invisible.html) self.

------------------------------------------------------------------------

### Method [`upload_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_directory_cnt.md)

Upload a directory to the file storage. See also
[upload_directory_cnt](https://novonordisk-opensource.github.io/connector/reference/upload_directory_cnt.md).

#### Usage

    ConnectorFS$upload_directory_cnt(src, dest = basename(src), ...)

#### Arguments

- `src`:

  [character](https://rdrr.io/r/base/character.html) The path to the
  directory to upload

- `dest`:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to create

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

[invisible](https://rdrr.io/r/base/invisible.html) self.

------------------------------------------------------------------------

### Method [`download_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_directory_cnt.md)

Download a directory from the file storage. See also
[download_directory_cnt](https://novonordisk-opensource.github.io/connector/reference/download_directory_cnt.md).

#### Usage

    ConnectorFS$download_directory_cnt(src, dest = basename(src), ...)

#### Arguments

- `src`:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to download from the connector

- `dest`:

  [character](https://rdrr.io/r/base/character.html) The path to the
  directory to download to

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.

------------------------------------------------------------------------

### Method [`tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.md)

Use dplyr verbs to interact with the tibble. See also
[tbl_cnt](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.md).

#### Usage

    ConnectorFS$tbl_cnt(name, ...)

#### Arguments

- `name`:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- `...`:

  Additional arguments passed to the method for the individual
  connector.

#### Returns

A table object.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ConnectorFS$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Create file storage connector

folder <- withr::local_tempdir("test", .local_envir = .GlobalEnv)



cnt <- ConnectorFS$new(folder)
cnt
#> <ConnectorFS>
#> Inherits from: <Connector>
#> Registered methods:
#> • `check_resource.ConnectorFS()`
#> • `create_directory_cnt.ConnectorFS()`
#> • `download_cnt.ConnectorFS()`
#> • `download_directory_cnt.ConnectorFS()`
#> • `list_content_cnt.ConnectorFS()`
#> • `log_read_connector.ConnectorFS()`
#> • `log_remove_connector.ConnectorFS()`
#> • `log_write_connector.ConnectorFS()`
#> • `read_cnt.ConnectorFS()`
#> • `remove_cnt.ConnectorFS()`
#> • `remove_directory_cnt.ConnectorFS()`
#> • `tbl_cnt.ConnectorFS()`
#> • `upload_cnt.ConnectorFS()`
#> • `upload_directory_cnt.ConnectorFS()`
#> • `write_cnt.ConnectorFS()`
#> Specifications:
#> • path: /tmp/RtmpAUXnEM/test1d577a41e280

# You can do the same thing using wrapper function connector_fs()
cnt <- connector_fs(folder)
cnt
#> <ConnectorFS>
#> Inherits from: <Connector>
#> Registered methods:
#> • `check_resource.ConnectorFS()`
#> • `create_directory_cnt.ConnectorFS()`
#> • `download_cnt.ConnectorFS()`
#> • `download_directory_cnt.ConnectorFS()`
#> • `list_content_cnt.ConnectorFS()`
#> • `log_read_connector.ConnectorFS()`
#> • `log_remove_connector.ConnectorFS()`
#> • `log_write_connector.ConnectorFS()`
#> • `read_cnt.ConnectorFS()`
#> • `remove_cnt.ConnectorFS()`
#> • `remove_directory_cnt.ConnectorFS()`
#> • `tbl_cnt.ConnectorFS()`
#> • `upload_cnt.ConnectorFS()`
#> • `upload_directory_cnt.ConnectorFS()`
#> • `write_cnt.ConnectorFS()`
#> Specifications:
#> • path: /tmp/RtmpAUXnEM/test1d577a41e280

# List content
cnt$list_content_cnt()
#> character(0)

# Write to the connector
cnt$write_cnt(iris, "iris.rds")

# Check it is there
cnt$list_content_cnt()
#> [1] "iris.rds"

# Read the result back
cnt$read_cnt("iris.rds") |>
  head()
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
```
