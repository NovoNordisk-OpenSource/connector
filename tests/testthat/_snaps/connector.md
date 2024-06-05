# Connect datasources to the connections for a yaml file

    Code
      iris_f %>% dplyr::collect()
    Output
      # A tibble: 118 x 5
         Sepal.Length Sepal.Width Petal.Length Petal.Width Species
                <dbl>       <dbl>        <dbl>       <dbl> <chr>  
       1          5.1         3.5          1.4         0.2 setosa 
       2          5.4         3.9          1.7         0.4 setosa 
       3          5.4         3.7          1.5         0.2 setosa 
       4          5.8         4            1.2         0.2 setosa 
       5          5.7         4.4          1.5         0.4 setosa 
       6          5.4         3.9          1.3         0.4 setosa 
       7          5.1         3.5          1.4         0.3 setosa 
       8          5.7         3.8          1.7         0.3 setosa 
       9          5.1         3.8          1.5         0.3 setosa 
      10          5.4         3.4          1.7         0.2 setosa 
      # i 108 more rows

