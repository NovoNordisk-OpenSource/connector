pkgload::load_all()

## if metadata exists

yaml_file <- read_file(system.file("config", "default_config.yml", package = "connector"), eval.expr = TRUE)

sans_metadata <- list(datasources = list(ok = "test"))
old_metadata <- yaml_file[["metadata"]]



## example of metadata list


new_metadata <- list(
  trial = "test",
  something_new = "ok"
)


field_to_replace <- names(new_metadata)

for(i in field_to_replace){
  old_metadata[i] <- new_metadata[i]
}

old_metadata


## example of sans metadata list

old_metadata <- sans_metadata[["metadata"]]

new_metadata <- list(
  trial = "test",
  something_new = "ok"
)

config["metadata"] <- change_to_new_md(old_metadata)