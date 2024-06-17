yaml_file <- system.file("config", "default_config.yml", package = "connector")
yaml::read_yaml(yaml_file, eval.expr = TRUE) |>
  str()

yaml_file |>
  read_yaml_config() -> yaml_content

backend <- config$connections[[1]]$backend

connect <- yaml_file |>
  read_yaml_config() |>
  connect_from_yaml()

# str()# create the connections
connect <- connect_from_yaml(yaml_content)
