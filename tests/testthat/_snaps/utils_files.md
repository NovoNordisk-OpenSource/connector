# Test utils for file

    Code
      supported_fs()
    Output
      [1] "read_ext.csv"      "read_ext.default"  "read_ext.parquet" 
      [4] "read_ext.rds"      "read_ext.sas7bdat" "read_ext.txt"     
      [7] "read_ext.xpt"     

---

    No method found for this extension, please implement your own method (to see an example run `connector::example_read_ext()`) or use a supported extension
    i Supported extensions are:
    * read_ext.csv
    * read_ext.default
    * read_ext.parquet
    * read_ext.rds
    * read_ext.sas7bdat
    * read_ext.txt
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
      
