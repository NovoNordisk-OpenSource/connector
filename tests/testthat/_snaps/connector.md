# can create Connector object

    Code
      connector_obj
    Message
      <connector::connectors/list/S7_object>
        $test <ConnectorFS>

# Test connector creation [plain]

    Code
      test
    Output
       [1] "<ConnectorFS>"                           
       [2] "Inherits from: <Connector>"              
       [3] "Registered methods:"                     
       [4] "* `check_resource.ConnectorFS()`"        
       [5] "* `create_directory_cnt.ConnectorFS()`"  
       [6] "* `download_cnt.ConnectorFS()`"          
       [7] "* `download_directory_cnt.ConnectorFS()`"
       [8] "* `list_content_cnt.ConnectorFS()`"      
       [9] "* `log_read_connector.ConnectorFS()`"    
      [10] "* `log_remove_connector.ConnectorFS()`"  
      [11] "* `log_write_connector.ConnectorFS()`"   
      [12] "* `read_cnt.ConnectorFS()`"              
      [13] "* `remove_cnt.ConnectorFS()`"            
      [14] "* `remove_directory_cnt.ConnectorFS()`"  
      [15] "* `tbl_cnt.ConnectorFS()`"               
      [16] "* `upload_cnt.ConnectorFS()`"            
      [17] "* `upload_directory_cnt.ConnectorFS()`"  
      [18] "* `write_cnt.ConnectorFS()`"             
      [19] "Specifications:"                         
      [20] "* path: ."                               

# Test connector creation [ansi]

    Code
      test
    Output
       [1] "\033[34m<ConnectorFS>\033[39m"                           
       [2] "Inherits from: \033[34m<Connector>\033[39m"              
       [3] "Registered methods:"                                     
       [4] "\033[36m*\033[39m `check_resource.ConnectorFS()`"        
       [5] "\033[36m*\033[39m `create_directory_cnt.ConnectorFS()`"  
       [6] "\033[36m*\033[39m `download_cnt.ConnectorFS()`"          
       [7] "\033[36m*\033[39m `download_directory_cnt.ConnectorFS()`"
       [8] "\033[36m*\033[39m `list_content_cnt.ConnectorFS()`"      
       [9] "\033[36m*\033[39m `log_read_connector.ConnectorFS()`"    
      [10] "\033[36m*\033[39m `log_remove_connector.ConnectorFS()`"  
      [11] "\033[36m*\033[39m `log_write_connector.ConnectorFS()`"   
      [12] "\033[36m*\033[39m `read_cnt.ConnectorFS()`"              
      [13] "\033[36m*\033[39m `remove_cnt.ConnectorFS()`"            
      [14] "\033[36m*\033[39m `remove_directory_cnt.ConnectorFS()`"  
      [15] "\033[36m*\033[39m `tbl_cnt.ConnectorFS()`"               
      [16] "\033[36m*\033[39m `upload_cnt.ConnectorFS()`"            
      [17] "\033[36m*\033[39m `upload_directory_cnt.ConnectorFS()`"  
      [18] "\033[36m*\033[39m `write_cnt.ConnectorFS()`"             
      [19] "Specifications:"                                         
      [20] "\033[36m*\033[39m path: ."                               

# Test connector creation [unicode]

    Code
      test
    Output
       [1] "<ConnectorFS>"                           
       [2] "Inherits from: <Connector>"              
       [3] "Registered methods:"                     
       [4] "• `check_resource.ConnectorFS()`"        
       [5] "• `create_directory_cnt.ConnectorFS()`"  
       [6] "• `download_cnt.ConnectorFS()`"          
       [7] "• `download_directory_cnt.ConnectorFS()`"
       [8] "• `list_content_cnt.ConnectorFS()`"      
       [9] "• `log_read_connector.ConnectorFS()`"    
      [10] "• `log_remove_connector.ConnectorFS()`"  
      [11] "• `log_write_connector.ConnectorFS()`"   
      [12] "• `read_cnt.ConnectorFS()`"              
      [13] "• `remove_cnt.ConnectorFS()`"            
      [14] "• `remove_directory_cnt.ConnectorFS()`"  
      [15] "• `tbl_cnt.ConnectorFS()`"               
      [16] "• `upload_cnt.ConnectorFS()`"            
      [17] "• `upload_directory_cnt.ConnectorFS()`"  
      [18] "• `write_cnt.ConnectorFS()`"             
      [19] "Specifications:"                         
      [20] "• path: ."                               

# Test connector creation [fancy]

    Code
      test
    Output
       [1] "\033[34m<ConnectorFS>\033[39m"                           
       [2] "Inherits from: \033[34m<Connector>\033[39m"              
       [3] "Registered methods:"                                     
       [4] "\033[36m•\033[39m `check_resource.ConnectorFS()`"        
       [5] "\033[36m•\033[39m `create_directory_cnt.ConnectorFS()`"  
       [6] "\033[36m•\033[39m `download_cnt.ConnectorFS()`"          
       [7] "\033[36m•\033[39m `download_directory_cnt.ConnectorFS()`"
       [8] "\033[36m•\033[39m `list_content_cnt.ConnectorFS()`"      
       [9] "\033[36m•\033[39m `log_read_connector.ConnectorFS()`"    
      [10] "\033[36m•\033[39m `log_remove_connector.ConnectorFS()`"  
      [11] "\033[36m•\033[39m `log_write_connector.ConnectorFS()`"   
      [12] "\033[36m•\033[39m `read_cnt.ConnectorFS()`"              
      [13] "\033[36m•\033[39m `remove_cnt.ConnectorFS()`"            
      [14] "\033[36m•\033[39m `remove_directory_cnt.ConnectorFS()`"  
      [15] "\033[36m•\033[39m `tbl_cnt.ConnectorFS()`"               
      [16] "\033[36m•\033[39m `upload_cnt.ConnectorFS()`"            
      [17] "\033[36m•\033[39m `upload_directory_cnt.ConnectorFS()`"  
      [18] "\033[36m•\033[39m `write_cnt.ConnectorFS()`"             
      [19] "Specifications:"                                         
      [20] "\033[36m•\033[39m path: ."                               

# can create Connector object [plain]

    Code
      test
    Output
       [1] ""                                                                                
       [2] "-- Datasources -----------------------------------------------------------------"
       [3] ""                                                                                
       [4] "-- test --"                                                                      
       [5] ""                                                                                
       [6] "* Backend Type: \"NA; R object instead of a call.\""                             
       [7] ""                                                                                
       [8] "-- Datasources -----------------------------------------------------------------"
       [9] ""                                                                                
      [10] "-- test --"                                                                      
      [11] ""                                                                                
      [12] "* Backend Type: \"NA; R object instead of a call.\""                             

# can create Connector object [ansi]

    Code
      test
    Output
       [1] ""                                                                                                                               
       [2] "\033[36m--\033[39m \033[1mDatasources\033[22m \033[36m-----------------------------------------------------------------\033[39m"
       [3] ""                                                                                                                               
       [4] "-- \033[1m\033[1mtest\033[1m\033[22m --"                                                                                        
       [5] ""                                                                                                                               
       [6] "* Backend Type: \033[34m\"NA; R object instead of a call.\"\033[39m"                                                            
       [7] ""                                                                                                                               
       [8] "\033[36m--\033[39m \033[1mDatasources\033[22m \033[36m-----------------------------------------------------------------\033[39m"
       [9] ""                                                                                                                               
      [10] "-- \033[1m\033[1mtest\033[1m\033[22m --"                                                                                        
      [11] ""                                                                                                                               
      [12] "* Backend Type: \033[34m\"NA; R object instead of a call.\"\033[39m"                                                            

# can create Connector object [unicode]

    Code
      test
    Output
       [1] ""                                                                                
       [2] "── Datasources ─────────────────────────────────────────────────────────────────"
       [3] ""                                                                                
       [4] "── test ──"                                                                      
       [5] ""                                                                                
       [6] "• Backend Type: \"NA; R object instead of a call.\""                             
       [7] ""                                                                                
       [8] "── Datasources ─────────────────────────────────────────────────────────────────"
       [9] ""                                                                                
      [10] "── test ──"                                                                      
      [11] ""                                                                                
      [12] "• Backend Type: \"NA; R object instead of a call.\""                             

# can create Connector object [fancy]

    Code
      test
    Output
       [1] ""                                                                                                                               
       [2] "\033[36m──\033[39m \033[1mDatasources\033[22m \033[36m─────────────────────────────────────────────────────────────────\033[39m"
       [3] ""                                                                                                                               
       [4] "── \033[1m\033[1mtest\033[1m\033[22m ──"                                                                                        
       [5] ""                                                                                                                               
       [6] "• Backend Type: \033[34m\"NA; R object instead of a call.\"\033[39m"                                                            
       [7] ""                                                                                                                               
       [8] "\033[36m──\033[39m \033[1mDatasources\033[22m \033[36m─────────────────────────────────────────────────────────────────\033[39m"
       [9] ""                                                                                                                               
      [10] "── \033[1m\033[1mtest\033[1m\033[22m ──"                                                                                        
      [11] ""                                                                                                                               
      [12] "• Backend Type: \033[34m\"NA; R object instead of a call.\"\033[39m"                                                            

