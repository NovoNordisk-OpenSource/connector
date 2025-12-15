# How to extend connector

`connector` is build to be easily extensible. This vignette will show
you how to create your own connector classes, and how to customize the
existing ones, and their methods.

The basic `Connector` class is a simple [R6](https://r6.r-lib.org)
object, with no methods but provides
[`check_resource()`](https://novonordisk-opensource.github.io/connector/reference/resource-validation.md)
as a default validation mechanism that can be overridden by child
classes to verify their specific resource requirements.

It serves as the foundation for all other connectors, that should
inherit from it in their
[`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
definition - either directly or indirectly. Both `ConnectorFS` and
`ConnectorDBI` inherit from `Connector` in this way.

Before we start creating our own connector classes, you can read the
vignette on the [Consistent
API](https://novonordisk-opensource.github.io/connector/articles/Consistent-API.html)
to understand how the methods are structured and what they return.

## Creating a new connector

We can create a new connector by creating a new R6 class that inherits
from `Connector`:

``` r
connector_myclass <- R6::R6Class(
  "connector_myclass",
  inherit = Connector
)

connector_myclass$new()
#> <connector_myclass/Connector>
#> Registered methods:
#> • `check_resource.Connector()`
```

This is the simplest type of inheritance, and you should note that the
`Connector` parent class has no methods capable of e.g. reading
([`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md))
or writing
([`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md))
data. It only has default methods that throws meaningful errors if you
have not defined the method (e.g. `write_cnt.my_class()`) for your new
connector class.

In most cases you want to inherit from either `ConnectorFS` or
`ConnectorDBI` depending on if your new connector is used to access
files or databases respectively.

Below we create a new `connector_project` class that inherits and acts
exactly as the `ConnectorFS`, but instead of the user having to provide
the `path` to the folder as an argument, they provide the `project`
name, and the `path` is constructed from that.

``` r
connector_project <- R6::R6Class(
  "connector_project",
  inherit = ConnectorFS,
  public = list(
    initialize = function(project) {
      private$.project <- project
      path <- file.path(tmp, "my_root_path", project)
      super$initialize(path)
    }
  ),
  private = list(
    .project = NULL
  ),
  active = list(
    project = function() {
      private$.project
    }
  )
)
```

This way of extending connector could e.g. be relevant inside an
organisation where all projects are stored in a common folder structure.

When we now initialize a `connector_project` you can see that it still
has all the methods from `ConnectorFS`, and that the path has been
assigned correctly based on the `project` argument:

``` r
my_project <- connector_project$new(project = "my_project")

print(my_project)
#> <connector_project/ConnectorFS>
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
#> • path: /tmp/Rtmpt5x0j3/file298e6769203c/my_root_path/my_project
#> • project: my_project
```

We can now use this `connector` to read and write data, just as we would
with `ConnectorFS`:

``` r
# First list current content:
my_project |>
  list_content_cnt()
#> character(0)

# Write some content:
my_project |>
  write_cnt("Hello world!", "my_file.txt")

# List content again:
my_project |>
  list_content_cnt()
#> [1] "my_file.txt"

# Read the content:
my_project |>
  read_cnt("my_file.txt")
#> → Found one file: /tmp/Rtmpt5x0j3/file298e6769203c/my_root_path/my_project/my_file.txt
#> [1] "Hello world!"
```

## Create custom generic method

All `connector`generics such as
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md),
[`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md),
and
[`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md)
are S3 generics. This means that you can create custom methods for your
new connector class, and they will be used when the generic is called,
instead of the one associated with the parent class.

To illustrate this we can take a look at the
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md)
generic:

``` r
# Print the generic
print(list_content_cnt)
#> function (connector_object, ...) 
#> {
#>     UseMethod("list_content_cnt")
#> }
#> <bytecode: 0x55b39ee170a0>
#> <environment: namespace:connector>

# List the registered s3 methods
methods("list_content_cnt") |>
  cat(sep = "\n")
#> list_content_cnt.ConnectorDBI
#> list_content_cnt.ConnectorFS
#> list_content_cnt.ConnectorLogger
#> list_content_cnt.default
```

Building further on the example below we can define a custom method for
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md)
for the `connector_project` class, to be used instead of
`list_content_cnt.ConnectorFS`:

``` r
list_content_cnt.connector_project <- function(connector_object, ...) {
  cli::cli_alert("Listing content of {connector_object$project}")
  NextMethod()
}
```

This is of course a very simple example, that just prints a message
before calling the `ConnectorFS` method.

We can now see that this method is available and that is it associated
with the `connector_project` class:

``` r
# List methods again
methods("list_content_cnt") |>
  cat(sep = "\n")
#> list_content_cnt.connector_project
#> list_content_cnt.ConnectorDBI
#> list_content_cnt.ConnectorFS
#> list_content_cnt.ConnectorLogger
#> list_content_cnt.default

# Print my_project connector to see associated methods
print(my_project)
#> <connector_project/ConnectorFS>
#> Inherits from: <Connector>
#> Registered methods:
#> • `list_content_cnt.connector_project()`
#> • `check_resource.ConnectorFS()`
#> • `create_directory_cnt.ConnectorFS()`
#> • `download_cnt.ConnectorFS()`
#> • `download_directory_cnt.ConnectorFS()`
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
#> • path: /tmp/Rtmpt5x0j3/file298e6769203c/my_root_path/my_project
#> • project: my_project
```

And when we use
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md)
on our `my_project` object, we see that the custom method is used and we
get the message:

``` r
my_project |>
  list_content_cnt()
#> → Listing content of my_project
#> [1] "my_file.txt"
```

## Use extra class for simple customization

If you as above just want to slightly tweak the behavior of an existing
functionality an alternative solution is to use the `extra_class`
argument when initializing of the connector.

This argument adds the `extra_class` as the first class of the creating
the connector, meaning that for any generic dispatch, such as of
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md),
a method for this class will be used before any of the connector
classes.

To redo the two examples above we make a new `ConnectorFS` with the
extra class `extra_class`:

``` r
my_project_extra <- ConnectorFS$new(
  path = file.path(tmp, "my_root_path", "my_project"),
  extra_class = "my_extra_class"
)

print(my_project_extra)
#> <my_extra_class/ConnectorFS>
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
#> • path: /tmp/Rtmpt5x0j3/file298e6769203c/my_root_path/my_project
```

As you can see here we have all the methods from `ConnectorFS`, but the
`extra_class` is now the first class in the class hierarchy.

To create a custom method for
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.md)
for the `extra_class` we do the same as for the `connector_project`
above:

``` r
list_content_cnt.my_extra_class <- function(connector_object, ...) {
  cli::cli_alert("Listing content of {connector_object$path}")
  NextMethod()
}
```

The project information is of course not available now, so we just print
the path instead, but otherwise everything is the same:

``` r
# List methods
methods("list_content_cnt")
#> [1] list_content_cnt.connector_project list_content_cnt.ConnectorDBI*    
#> [3] list_content_cnt.ConnectorFS*      list_content_cnt.ConnectorLogger* 
#> [5] list_content_cnt.default*          list_content_cnt.my_extra_class   
#> see '?methods' for accessing help and source code

# Print my_project_extra connector to see associated methods
print(my_project_extra)
#> <my_extra_class/ConnectorFS>
#> Inherits from: <Connector>
#> Registered methods:
#> • `list_content_cnt.my_extra_class()`
#> • `check_resource.ConnectorFS()`
#> • `create_directory_cnt.ConnectorFS()`
#> • `download_cnt.ConnectorFS()`
#> • `download_directory_cnt.ConnectorFS()`
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
#> • path: /tmp/Rtmpt5x0j3/file298e6769203c/my_root_path/my_project

# List content to see the new message
my_project_extra |>
  list_content_cnt()
#> → Listing content of /tmp/Rtmpt5x0j3/file298e6769203c/my_root_path/my_project
#> [1] "my_file.txt"
```

## Special handling of files

A special property of file storage connectors (inheriting from
`ConnectorFS`) is that they are operating on files not on databases.
This means that they can handle multiple file formats, and also not only
file formats for reading and writing rectangular data.

When handling files the user will only use the
[`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
and
[`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md)
generics, but behind the scenes the following chain of functions are
called:

- [`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
  –\>
  [`read_file()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md)
  –\>
  [`read_ext()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md)
  –\> External read function
- [`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md)
  –\>
  [`write_file()`](https://novonordisk-opensource.github.io/connector/reference/write_file.md)
  –\>
  [`write_ext()`](https://novonordisk-opensource.github.io/connector/reference/write_file.md)
  –\> External write function

Here
[`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
dispatches based on the class of the `Connector` object. For the file
storage connectors (inheriting from `ConnectorFS`) the
[`read_file()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md)
method is then called on the path of the file.

[`read_file()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md)
here is only a helper function, that then calls
[`read_ext()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md)
which is a generic that dispatches based on file extension of the file,
and uses general functions from other packages to read the file. As an
example any file with the extension `.csv` will be read using
[`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).

The same logic applies to
[`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md).

### Add new file format

The currently supported file types can be seen in reference of the
[`read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/read_cnt.md)
and
[`write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.md)
functions respectively.

But let us imagine we want to support a new imaginary file format
`myformat`. In order to this all we need to do is to create the
appropriate
[`read_ext()`](https://novonordisk-opensource.github.io/connector/reference/read_file.md)
and
[`write_ext()`](https://novonordisk-opensource.github.io/connector/reference/write_file.md)
methods:

``` r
read_ext.myformat <- function(path, ...) {
  cli::cli_alert("Reading myformat file")
  readLines(con = path)
}

write_ext.myformat <- function(file, x, ...) {
  cli::cli_alert("Writing myformat file")
  writeLines(text = x, con = file)
}
```

And we can now use them to write and read our new file format with out
existing `my_project` connector:

``` r
# List already existing content:
my_project |>
  list_content_cnt()
#> → Listing content of my_project
#> [1] "my_file.txt"

# Write some content in myformat:
my_project |>
  write_cnt("Hello new format!", "new_file.myformat")
#> → Writing myformat file

# List content again:
my_project |>
  list_content_cnt()
#> → Listing content of my_project
#> [1] "my_file.txt"       "new_file.myformat"

# Read the content:
my_project |>
  read_cnt("new_file.myformat")
#> → Found one file: /tmp/Rtmpt5x0j3/file298e6769203c/my_root_path/my_project/new_file.myformat
#> → Reading myformat file
#> [1] "Hello new format!"
```
