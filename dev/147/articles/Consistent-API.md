# Understanding Connector Package Methods

## Introduction

We realized it might be confusing for users to understand which method
returns which value. This vignette explains what each method does and
provides an overview of general rules. This information is also helpful
for developers creating their own connector packages, as it outlines
what each method should return to maintain consistency and
interoperability between different connector packages.

## Methods and Return Values

Below is a table summarizing the methods and their return values:

| Method                                                                                                               | Return Value                                                                                                                                                                                   |
|----------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)                             | Content of the file                                                                                                                                                                            |
| [`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md)                           | `Connector` object                                                                                                                                                                             |
| [`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md)             | Vector of items                                                                                                                                                                                |
| [`remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.md)                         | `Connector` object                                                                                                                                                                             |
| [`download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_cnt.md)                     | `Connector` object                                                                                                                                                                             |
| [`upload_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_cnt.md)                         | `Connector` object                                                                                                                                                                             |
| [`create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/create_directory_cnt.md)     | `Connector` object, if `open = TRUE`, then new `Connector` object                                                                                                                              |
| [`remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.md)     | `Connector` object                                                                                                                                                                             |
| [`upload_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_directory_cnt.md)     | `Connector` object, if `open = TRUE`, then new `Connector` object                                                                                                                              |
| [`download_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_directory_cnt.md) | `Connector` object                                                                                                                                                                             |
| [`tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.md)                               | Content of the table. Either [`dplyr::tbl()`](https://dplyr.tidyverse.org/reference/tbl.html) or from [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md) |

## Detailed Explanations

### `read_cnt()`

Reads the content of a file and returns it directly. This allows users
to immediately work with the data without additional steps.

### `write_cnt()`

After writing content to the `Connector`, this method returns the
`Connector` object. This enables method chaining and provides
confirmation that the write operation was successful.

### `list_content_cnt()`

Returns a `character` vector of items (files/directories) in the current
`Connector` allowing users to explore the content structure.

### `remove_cnt()`

After removing a file or item, this method returns the `Connector`
object, allowing for further operations and confirming the removal was
successful.

### `download_cnt()`

This method returns the `Connector` object after a download operation to
allow for method chaining.

### `upload_cnt()`

Similar to
[`download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_cnt.md),
this returns the `Connector` object after an upload, allowing for method
chaining.

### `create_directory_cnt()`

This method returns the `Connector` object. If the `open` parameter is
set to `TRUE`, it returns a new `Connector` object pointing to the newly
created directory.

### `remove_directory_cnt()`

After removing a directory, this method returns the `Connector` object,
allowing for further operations and confirming the removal was
successful.

### `upload_directory_cnt()`

Returns the current `Connector` object or a new one if the directory was
opened (`open = TRUE`), allowing for immediate use of the uploaded
directory.

### `download_directory_cnt()`

Returns the `Connector` object to allow for method chaining.

### `tbl_cnt()`

This method returns the content of a file in a tabular format. For
file-based connectors, it typically uses
[`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
to get the content. For database connections (`DBI`), it returns a
[`dplyr::tbl()`](https://dplyr.tidyverse.org/reference/tbl.html)
representation of the data.
