#' Transform Test Data to Datasources
#'
#' This function takes a list of function calls, extracts their information,
#' transforms them into backends, and finally wraps them in a datasources structure.
#'
#' @param data A list of function calls as expressions.
#' @return A list with a 'datasources' element containing the transformed backends.
#'
#' @importFrom purrr imap
#' @importFrom rlang expr_text
#'
connectors_to_datasources <- function(data) {
  data[-1] |>
    as.list() |>
    purrr::imap(~ {
      deparse(.x) |>
        extract_function_info() |>
        transform_as_backend(.y)
    }) |>
    unname() |>
    transform_as_datasources()
}

#' Transform Clean Function Info to Backend Format
#'
#' This function takes the output of `extract_function_info` and transforms it
#' into a backend format suitable for further processing or API integration.
#'
#' @param infos A list with class "clean_fct_info", typically the output of `extract_function_info`.
#' @param name A character string representing the name to be assigned to the backend.
#'
#' @return A list representing the backend, with 'name' and 'backend' components or an error if the input is not of class "clean_fct_info".
#'
#' @importFrom cli cli_abort
#' @keywords internal
transform_as_backend <- function(infos, name) {
  if (!inherits(infos, "clean_fct_info")) {
    cli::cli_abort("You should use the extract_function_info function before calling this function")
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

#' Transform Multiple Backends to Datasources Format
#'
#' This function takes a list of backends (typically created by `transform_as_backend`)
#' and wraps them in a 'datasources' list. This is useful for creating a structure
#' that represents multiple data sources or backends.
#'
#' @param bks A list of backends, each typically created by `transform_as_backend`.
#'
#' @return A list with a single 'datasources' element containing all input backends.
#'
#' @keywords internal
transform_as_datasources <- function(bks) {
  as_datasources(
    list(
      datasources = bks
    )
  )
}

#' Extract Function Information
#'
#' This function extracts detailed information about a function call,
#' including its name, package, parameters, and whether it's an R6 class constructor.
#'
#' @param func_string A character string representing the function call.
#' @return A list with class "clean_fct_info" containing:
#'   \item{function_name}{The name of the function or R6 class}
#'   \item{parameters}{A list of parameters passed to the function}
#'   \item{is_r6}{A boolean indicating whether it's an R6 class constructor}
#'   \item{package_name}{The name of the package containing the function}
#' @importFrom rlang parse_expr expr_text
#' @importFrom purrr compact
extract_function_info <- function(func_string) {
  # Parse the function string into an expression

  expr <- parse_expr(func_string)
  full_func_name <- expr_text(expr[[1]])

  # Check if it's an R6 class constructor
  is_r6 <- endsWith(full_func_name, "$new")

  # Extract basic information (package and function names)
  base_info <- extract_base_info(full_func_name, is_r6)

  # Get specific details based on whether it's R6 or standard function
  specific_info <- if (is_r6) {
    get_r6_specific_info(base_info$package_name, base_info$func_name)
  } else {
    get_standard_specific_info(base_info$package_name, base_info$func_name)
  }

  # Extract and process the parameters from the function call
  params <- extract_and_process_params(expr, specific_info$formal_args)

  # Construct and return the final result
  structure(
    compact(list(
      function_name = base_info$func_name,
      parameters = params,
      is_r6 = is_r6,
      package_name = base_info$package_name
    )),
    class = "clean_fct_info"
  )
}

#' Extract Base Information
#'
#' Extracts the package name and function/class name from the full function name.
#'
#' @param full_func_name The full name of the function (potentially including package).
#' @param is_r6 Boolean indicating whether it's an R6 class constructor.
#' @return A list with package_name and func_name.
#' @keywords internal
extract_base_info <- function(full_func_name, is_r6) {
  # Check if the function name includes a package specification
  if (grepl("::", full_func_name, fixed = TRUE)) {
    parts <- strsplit(full_func_name, "::")[[1]]
    package_name <- parts[1]
    func_name <- parts[2]
  } else {
    package_name <- NULL
    func_name <- full_func_name
  }

  # For R6, remove the "$new" suffix from the function name
  if (is_r6) {
    func_name <- sub("\\$new$", "", func_name)
  }

  # If package name is not specified, try to determine it
  if (is.null(package_name)) {
    package_name <- if (is_r6) {
      # For R6, get the package from the class's parent environment
      getNamespaceName(get(func_name)$parent_env)
    } else {
      # For standard functions, get the package from the function's environment
      getNamespaceName(environment(get(func_name)))
    }
  }

  list(package_name = package_name, func_name = func_name)
}

#' Get Standard Function Specific Information
#'
#' Retrieves the function object and its formal arguments for standard functions.
#'
#' @param package_name The name of the package containing the function.
#' @param func_name The name of the function.
#' @return A list with the function object and its formal arguments.
#' @keywords internal
get_standard_specific_info <- function(package_name, func_name) {
  func <- getExportedValue(package_name, func_name)
  formal_args <- names(formals(func))
  list(func = func, formal_args = formal_args)
}

#' Get R6 Class Specific Information
#'
#' Retrieves the initialize method and its formal arguments for R6 classes.
#'
#' @param package_name The name of the package containing the R6 class.
#' @param func_name The name of the R6 class.
#' @return A list with the initialize method and its formal arguments.
#' @keywords internal
get_r6_specific_info <- function(package_name, func_name) {
  class_obj <- getExportedValue(package_name, func_name)
  init_func <- class_obj$public_methods$initialize
  formal_args <- names(formals(init_func))
  list(func = init_func, formal_args = formal_args)
}

#' Extract and Process Parameters
#'
#' Extracts parameters from the function call and processes them.
#'
#' @param expr The parsed expression of the function call.
#' @param formal_args The formal arguments of the function.
#' @return A list of processed parameters.
#' @keywords internal
#' @importFrom rlang call_args is_symbol as_string eval_tidy
#' @importFrom purrr map
extract_and_process_params <- function(expr, formal_args) {
  # Extract parameters from the function call
  params <- call_args(expr)

  # Convert symbols to strings and evaluate expressions
  params <- map(params, ~ {
    if (is_symbol(.x)) {
      as.character(.x)
    } else if(rlang::is_call(.x)){
      as.character(deparse(.x))
    }  else {
      as.character(.x)
    }
  })

  # Process parameters based on whether the function uses ... or not
  if (formal_args[1] == "...") {
    process_ellipsis_params(params)
  } else {
    process_named_params(params, formal_args)
  }
}

#' Process Parameters for Functions with Ellipsis
#'
#' Handles parameter processing for functions that use ... in their arguments.
#'
#' @param params The extracted parameters from the function call.
#' @return A list of processed parameters.
#' @keywords internal
process_ellipsis_params <- function(params) {
  unnamed_args <- params[names(params) == ""]
  named_args <- params[names(params) != ""]
  unnamed_args <- unlist(unnamed_args)
  c(named_args, list("..." = unnamed_args))
}

#' Process Named Parameters
#'
#' Handles parameter processing for functions with named arguments.
#'
#' @param params The extracted parameters from the function call.
#' @param formal_args The formal arguments of the function.
#' @return A list of processed parameters.
#' @keywords internal
process_named_params <- function(params, formal_args) {
  unnamed_args <- params[names(params) == ""]
  named_args <- params[names(params) != ""]

  # Match unnamed arguments to their formal argument names
  if (length(unnamed_args) != 0) {
    u_formal_args <- formal_args[!formal_args %in% names(params)]
    u_formal_args <- u_formal_args[u_formal_args != "..."]
    u_formal_args <- u_formal_args[1:length(unnamed_args)]
    names(unnamed_args) <- u_formal_args
  } else {
    unnamed_args <- NULL
  }

  c(named_args, unnamed_args)
}
