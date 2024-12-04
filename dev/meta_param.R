pkgload::load_all()

## if metadata exists


yaml_file <- system.file("config", "default_config.yml", package = "connector")

sans_metadata <- list(datasources = list(ok = "test"))
old_metadata <- yaml_file[["metadata"]]

test <- connect(config = yaml_file, logging = TRUE)

test$adam$list_content_cnt()
test$adam

## example of metadata list

connectors(
  adam = connector_dbi$new()
)

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

## Try to add some extra info

test <- substitute(list(
  adam = connector_fs$new(path = "dev"),
  adam2 = connector_fs$new("dev")
)
)
as.character(test[2])

test2 <- as.character(test)
names(test2) <- names(test)
test2

clean_test2 <- test2[-1]
as.list(clean_test2)

ok <- "connector_fs$new(path = \"dev\")"
func_string <- "connector_fs$new(extra_class = \"dev\" ,\"dev\")"

library(rlang)
library(purrr)

#' Extrait les informations d'une fonction à partir d'une chaîne de caractères
#'
#' @param func_string La chaîne de caractères représentant l'appel de fonction
#' @return Une liste contenant les informations extraites de la fonction
extract_function_info <- function(func_string) {
  # Convertir la chaîne en expression
  expr <- parse_expr(func_string)

  # Extraire le nom complet de la fonction
  full_func_name <- expr_text(expr[[1]])
  # Séparer le package et le nom de la fonction
  if (grepl("::", full_func_name, fixed = TRUE)) {
    parts <- strsplit(full_func_name, "::")[[1]]
    package_name <- parts[1]
    func_name <- parts[2]
  } else {
    package_name <- NULL
    func_name <- full_func_name
  }

  # Vérifier si c'est une fonction R6
  is_r6 <- endsWith(func_name, "$new")
  if (is_r6) {
    func_name <- sub("\\$new$", "", func_name)
  }

  if(is.null(package_name)){
    if(is_r6){
      package_name <- getNamespaceName(get(func_name)$parent_env)
    }else{
      package_name <- getNamespaceName(environment(get(func_name)))
    }
  }

  # Obtenir la fonction
  func <- getExportedValue(package_name, func_name)


  # Obtenir les arguments formels
  if(is_r6){
    formal_args <- names(formals(func$public_methods$initialize))
  }else{
    formal_args <- names(formals(func))
  }


  # Extraire les paramètres de l'appel
  params <- call_args(expr)

  # Convertir les symboles en chaînes et évaluer les expressions
  params <- map(params, ~ if(is_symbol(.x)) as_string(.x) else eval_tidy(.x))

  # Nommer les paramètres non nommés selon l'ordre des arguments
  if(formal_args[1] == "..."){
    unnamed_args <- params[names(params) == ""]
    named_args <- params[names(params) != ""]
    unnamed_args <- unlist(unnamed_args)
    unnamed_args <- list("..." = unnamed_args)
  }else{
    unnamed_args <- params[names(params) == ""]
    named_args <- params[names(params) != ""]
    if(length(unnamed_args) != 0){
      u_formal_args <- formal_args[!formal_args %in% names(params)]
      u_formal_args <- u_formal_args[u_formal_args != "..."]
      u_formal_args <- u_formal_args[1:length(unnamed_args)]
      names(unnamed_args) <- u_formal_args
    }else{
      unnamed_args <- NULL
    }
  }

  params <- c(named_args, unnamed_args)

  # Créer et retourner la liste résultante
  structure(
    compact(
    list(
    function_name = func_name,
    parameters = params,
    is_r6 = is_r6,
    package_name = package_name
  )
), class = "clean_fct_info")

}

func_string <- "ggplot2::ggplot(mapping = ggplot2::aes(x = Species, y = Sepal.Length), data = iris)"
print(result1)

func_string <- 'base::paste("Hello", sep = " ", "World")'
print(result2)
as.character(rlang::parse_expr(func_string)[[1]][2])

func_string <- 'mean(c(1, 2, 3), na.rm = TRUE)'
print(result4)

func_string <- "connector_fs$new(extra_class = \"dev\" ,\"dev\")"


infos <- extract_function_info(func_string = func_string)

transform_as_backend <- function(infos, name) {
  if (!inherits(infos, "clean_fct_info")) {
    cli::cli_abort("You should use the extract_function_info fct before")
  }

  bk <- list(
    name = name,
    backend = list(
    type = paste0(infos$package_name, "::", infos$function_name)
  )
)
  bk$backend[names(infos$parameters)] <- infos$parameters

  return(bk)
}



transform_as_datasources <- function(bks){
  list(
    datasources = bks
  )
}

test <- substitute(
  list(
    adam = connector_fs$new(path = "dev"),
    adam2 = connector_fs$new(extra_class = "dev" ,"dev")
  )
)

test <- test[-1]
test <- as.list(test)

purrr::imap(test, ~ deparse(.x) |>
  extract_function_info() |>
  transform_as_backend(.y)) |>
  unname() |>
  transform_as_datasources() |>
  yaml::write_yaml("test.yml")

connect("test.yml")


