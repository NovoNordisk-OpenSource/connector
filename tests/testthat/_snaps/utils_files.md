# Test utils for file

    No method found for this extension, please implement your own method (to see an example run `connector::example_read_ext()`) or use a supported extension
    i Supported extensions are:
    * read_ext.csv
    * read_ext.default
    * read_ext.parquet
    * read_ext.rds
    * read_ext.sas7bdat
    * read_ext.xpt

---

    Code
      example_read_ext()
    Message
      Here an example for CSV files:
      > Your own method by creating a new function with the name `read_ext.<extension>`
      read_ext.csv <- function(path, ...) {
        readr::read_csv(path, ...)
      }
      

