# Test utils for file

    Code
      supported_fs()
    Output
       [1] "read_ext.csv"      "read_ext.default"  "read_ext.json"    
       [4] "read_ext.parquet"  "read_ext.rds"      "read_ext.sas7bdat"
       [7] "read_ext.txt"      "read_ext.xls"      "read_ext.xlsx"    
      [10] "read_ext.xpt"      "read_ext.yaml"     "read_ext.yml"     

---

    No method found for this extension, please implement your own method (to see an example run `connector::example_read_ext()`) or use a supported extension
    i Supported extensions are:
    * read_ext.csv
    * read_ext.default
    * read_ext.json
    * read_ext.parquet
    * read_ext.rds
    * read_ext.sas7bdat
    * read_ext.txt
    * read_ext.xls
    * read_ext.xlsx
    * read_ext.xpt
    * read_ext.yaml
    * read_ext.yml

---

    Code
      test
    Output
      [1] "Here an example for CSV files:"                                                   
      [2] "> Your own method by creating a new function with the name `read_ext.<extension>`"
      [3] "read_ext.csv <- function(path, ...) {"                                            
      [4] "  readr::read_csv(path, ...)"                                                     
      [5] "}"                                                                                
      [6] ""                                                                                 

