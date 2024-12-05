yaml_file <- system.file("config", "default_config.yml", package = "connector")
yaml_file_env <- system.file("config", "test_env_config.yml", package = "connector")
yaml_content_raw <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
yaml_content_parsed <- connector:::parse_config(yaml_content_raw)

# create the json file
# jsonlite::toJSON(yaml_content_raw, pretty = TRUE) |>
#   cat(file = "tests/testthat/config_json.json")
