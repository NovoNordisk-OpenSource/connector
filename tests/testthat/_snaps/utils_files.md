# test example_read [plain]

    Code
      test
    Output
      [1] "Here an example for CSV files:"                                                   
      [2] "> Your own method by creating a new function with the name `read_ext.<extension>`"
      [3] "read_ext.csv <- function(path, ...) {"                                            
      [4] "  readr::read_csv(path, ...)"                                                     
      [5] "}"                                                                                
      [6] ""                                                                                 

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
    * read_ext.xlsm
    * read_ext.xlsx
    * read_ext.xpt
    * read_ext.yaml
    * read_ext.yml

# test example_read [ansi]

    Code
      test
    Output
      [1] "\033[1m\033[22mHere an example for CSV files:"                                                                        
      [2] "> Your own method by creating a new function with the name `read_ext.<extension>`"                                    
      [3] "read_ext.csv \033[33m<-\033[39m \033[33mfunction\033[39m\033[33m(\033[39mpath, ...\033[33m)\033[39m \033[33m{\033[39m"
      [4] "  readr::\033[1mread_csv\033[22m\033[33m(\033[39mpath, ...\033[33m)\033[39m"                                          
      [5] "\033[33m}\033[39m"                                                                                                    
      [6] ""                                                                                                                     

---

    [1m[22mNo method found for this extension, please implement your own method (to see an example run `connector::example_read_ext()`) or use a supported extension
    [36mi[39m Supported extensions are:
    [36m*[39m read_ext.csv
    [36m*[39m read_ext.default
    [36m*[39m read_ext.json
    [36m*[39m read_ext.parquet
    [36m*[39m read_ext.rds
    [36m*[39m read_ext.sas7bdat
    [36m*[39m read_ext.txt
    [36m*[39m read_ext.xls
    [36m*[39m read_ext.xlsm
    [36m*[39m read_ext.xlsx
    [36m*[39m read_ext.xpt
    [36m*[39m read_ext.yaml
    [36m*[39m read_ext.yml

# test example_read [unicode]

    Code
      test
    Output
      [1] "Here an example for CSV files:"                                                   
      [2] "→ Your own method by creating a new function with the name `read_ext.<extension>`"
      [3] "read_ext.csv <- function(path, ...) {"                                            
      [4] "  readr::read_csv(path, ...)"                                                     
      [5] "}"                                                                                
      [6] ""                                                                                 

---

    No method found for this extension, please implement your own method (to see an example run `connector::example_read_ext()`) or use a supported extension
    ℹ Supported extensions are:
    • read_ext.csv
    • read_ext.default
    • read_ext.json
    • read_ext.parquet
    • read_ext.rds
    • read_ext.sas7bdat
    • read_ext.txt
    • read_ext.xls
    • read_ext.xlsm
    • read_ext.xlsx
    • read_ext.xpt
    • read_ext.yaml
    • read_ext.yml

# test example_read [fancy]

    Code
      test
    Output
      [1] "\033[1m\033[22mHere an example for CSV files:"                                                                        
      [2] "→ Your own method by creating a new function with the name `read_ext.<extension>`"                                    
      [3] "read_ext.csv \033[33m<-\033[39m \033[33mfunction\033[39m\033[33m(\033[39mpath, ...\033[33m)\033[39m \033[33m{\033[39m"
      [4] "  readr::\033[1mread_csv\033[22m\033[33m(\033[39mpath, ...\033[33m)\033[39m"                                          
      [5] "\033[33m}\033[39m"                                                                                                    
      [6] ""                                                                                                                     

---

    [1m[22mNo method found for this extension, please implement your own method (to see an example run `connector::example_read_ext()`) or use a supported extension
    [36mℹ[39m Supported extensions are:
    [36m•[39m read_ext.csv
    [36m•[39m read_ext.default
    [36m•[39m read_ext.json
    [36m•[39m read_ext.parquet
    [36m•[39m read_ext.rds
    [36m•[39m read_ext.sas7bdat
    [36m•[39m read_ext.txt
    [36m•[39m read_ext.xls
    [36m•[39m read_ext.xlsm
    [36m•[39m read_ext.xlsx
    [36m•[39m read_ext.xpt
    [36m•[39m read_ext.yaml
    [36m•[39m read_ext.yml

# Test utils for file

    Code
      supported_fs()
    Output
       [1] "read_ext.csv"      "read_ext.default"  "read_ext.json"    
       [4] "read_ext.parquet"  "read_ext.rds"      "read_ext.sas7bdat"
       [7] "read_ext.txt"      "read_ext.xls"      "read_ext.xlsm"    
      [10] "read_ext.xlsx"     "read_ext.xpt"      "read_ext.yaml"    
      [13] "read_ext.yml"     

