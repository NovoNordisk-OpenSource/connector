# Function to add metadata
add_metadata <- function(config_path, key, value) {
  config <- read_file(config_path, eval.expr = TRUE)
  config$metadata[[key]] <- value
  write_file(config, config_path)
  return(config)
}

# Function to remove metadata
remove_metadata <- function(config_path, key) {
  config <- read_file(config_path, eval.expr = TRUE)
  config$metadata[[key]] <- NULL
  write_file(config, config_path)
  return(config)
}

# Function to add a new datasource 
add_datasource <- function(config_path, name, backend) {
  config <- read_file(config_path, eval.expr = TRUE)
  new_datasource <- list(
    name = name,
    backend = backend
  )
  config$datasources <- c(config$datasources, list(new_datasource))
  write_file(config, config_path)
  return(config)
}

# Function to remove a datasource
remove_datasource <- function(config_path, name) {
  config <- read_file(config_path, eval.expr = TRUE)
  config$datasources <- config$datasources[!(sapply(config$datasources, function(x) x$name) == name)]
  write_file(config, config_path)
  return(config)
}

# Example usage:

# Read the YAML file
test_config <- system.file("config", "default_config.yml", package = "connector")
file.copy(test_config, "test_config.yaml")

# Add metadata
config <- add_metadata("test_config.yaml", "new_metadata", "new_value")

# Remove metadata
config <- remove_metadata("test_config.yaml", "new_metadata")

# Add a new datasource
# Define the backend as a named list
new_backend <- list(
  type = "connector_jdbc",
  driver = "org.postgresql.Driver",
  url = "jdbc:postgresql://localhost:5432/mydatabase",
  user = "username",
  password = "password"
)

# Add a new datasource with the defined backend
config <- add_datasource("test_config.yaml", "new_datasource", new_backend)

# Remove a datasource
config <- remove_datasource("test_config.yaml", "new_datasource")

unlink("test_config.yaml")
