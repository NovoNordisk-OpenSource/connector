  
temp_dir <- tempfile("connector")
dir.create(temp_dir)

system.file(package = "connector") |> 
  list.files(full.names = TRUE) |> 
  file.copy(
    to = temp_dir, 
    recursive = TRUE
  )

yaml_file <- file.path(temp_dir, "config", "default_config.yml")
yaml_file_env <- file.path(temp_dir, "config", "test_env_config.yml")

yaml_content_raw <- yaml::read_yaml(yaml_file, eval.expr = TRUE)
yaml_content_parsed <- connector:::parse_config(yaml_content_raw)

test_file_name <- function(prefix = "test_", suffix = ".csv", length = 10) {
  random_string <- paste0(
    sample(c(letters, LETTERS, 0:9), length, replace = TRUE),
    collapse = ""
  )
  result <- paste0(prefix, random_string, suffix)

  file.path(tempdir(), result)
}

local_create_config <- function(env = parent.frame()) {
  test_config <- file.path(temp_dir, "config", "default_config.yml")

  config_name <- test_file_name(suffix = ".yaml")
  file.copy(test_config, config_name)

  withr::defer(unlink(config_name), envir = env)

  config_name
}

expect_snapshot_out <- function(...) {
  test <- capture.output(type = "message", ...)
  expect_snapshot(test)
}
