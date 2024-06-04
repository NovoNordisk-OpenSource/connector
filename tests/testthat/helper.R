yaml_file <- system.file("config", "default_config.yml", package = "connector")
yaml_content <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
