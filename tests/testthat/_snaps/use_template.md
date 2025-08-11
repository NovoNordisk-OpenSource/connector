# Testing use_template

    Code
      readLines(config_file_path)
    Output
       [1] "metadata:"                                 
       [2] "  path: !expr withr::local_tempdir()"      
       [3] ""                                          
       [4] "datasources:"                              
       [5] "  - name: \"folder\""                      
       [6] "    backend:"                              
       [7] "        type: \"connector::connector_fs\"" 
       [8] "        path: \"{metadata.path}\""         
       [9] "  - name: \"database\""                    
      [10] "    backend:"                              
      [11] "        type: \"connector::connector_dbi\""
      [12] "        drv: \"RSQLite::SQLite()\""        
      [13] "        dbname: \":memory:\""              

