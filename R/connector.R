#' General connector object
#'
#' @description
#' This R6 class is a general class for all connectors.
#' It is used to define the methods that all connectors should have.
#' New connectors should inherit from this class,
#' and the methods described below should be implemented.
#'
#' @param name `r rd_connector_utils("name")`
#' @param x `r rd_connector_utils("x")`
#' @param overwrite `r rd_connector_utils("overwrite")`
#' @param ... `r rd_connector_utils("...")`
#' @param extra_class `r rd_connector_utils("extra_class")`
#'
#' @seealso `vignette("customize")` on how to create custom connectors and methods,
#' and concrete examples in [ConnectorFS] and [ConnectorDBI].
#'
#' @examples
#' # Create connector
#' cnt <- Connector$new()
#'
#' cnt
#'
#' # Standard error message if no method is implemented
#' cnt |>
#'   read_cnt("fake_data") |>
#'   try()
#'
#' # Connection with extra class
#' cnt_my_class <- Connector$new(extra_class = "my_class")
#'
#' cnt_my_class
#'
#' # Custom method for the extra class
#' read_cnt.my_class <- function(connector_object) "Hello!"
#' registerS3method("read_cnt", "my_class", "read_cnt.my_class")
#'
#' cnt_my_class
#'
#' read_cnt(cnt_my_class)
#'
#' @export
Connector <- R6::R6Class(
  classname = "Connector",
  public = list(

    #' @description
    #' Initialize the connector with the option of adding an extra class.
    initialize = function(extra_class = NULL) {
      checkmate::assert_character(x = extra_class, any.missing = FALSE, null.ok = TRUE)
      class(self) <- c(extra_class, class(self))
    },

    #' @description
    #' Print method for a connector showing the registered methods and
    #' specifications from the active bindings.
    #' @return `r rd_connector_utils("inv_self")`
    print = function() {
      self |>
        print_cnt()
    },

    #' @description
    #' List available content from the connector. See also [list_content_cnt].
    #' @return A [character] vector of content names
    list_content_cnt = function(...) {
      self |>
        list_content_cnt(...)
    },

    #' @description
    #' Read content from the connector. See also [read_cnt].
    #' @return
    #' R object with the content. For rectangular data a [data.frame].
    read_cnt = function(name, ...) {
      self |>
        read_cnt(name, ...)
    },

    #' @description
    #' Write content to the connector.See also [write_cnt].
    #' @return `r rd_connector_utils("inv_self")`
    write_cnt = function(x, name, overwrite = FALSE, ...) {
      self |>
        write_cnt(x, name, ...)
    },

    #' @description
    #' Remove or delete content from the connector. See also [remove_cnt].
    #' @return `r rd_connector_utils("inv_self")`
    remove_cnt = function(name, ...) {
      self |>
        remove_cnt(name, ...)
    }
  )
)

#' Print method for connector objects
#' @return Invisible `connector_object`
#' @noRd
print_cnt <- function(connector_object) {
  methods <- list_methods(connector_object)

  packages <- methods |>
    strsplit(split = "\\.") |>
    lapply(\(x) utils::getS3method(f = x[[1]], class = x[[2]])) |>
    lapply(environment) |>
    lapply(environmentName) |>
    unlist(use.names = FALSE)

  links <- ifelse(
    rlang::is_interactive(),
    "{.help [{.fun {{methods}}}]({{packages}}::{{methods}})}",
    "{.fun {{methods}}}"
  ) |>
    glue::glue(.open = "{{", .close = "}}") |>
    rlang::set_names("*")

  classes <- class(connector_object)
  class_connector <- grepl("^Connector", classes) |>
    which() |>
    utils::head(1)

  specs <- if (R6::is.R6(connector_object)) {
    connector_object$.__enclos_env__$.__active__
  } else {
    NULL
  }

  if (length(specs) == 0) {
    specs <- NULL
  }

  if (!is.null(specs)) {
    specs <- specs |>
      names() |>
      rlang::set_names() |>
      lapply(\(x) {
        y <- connector_object[[x]]
        if (!is.character(y) & !is.numeric(y)) {
          y <- paste0("{.cls ", class(y), "}")
        }
        y
      }) |>
      unlist()
  }

  classes <- classes[classes != "R6"]

  cli::cli_bullets(
    c(
      "{.cls {utils::head(classes, class_connector)}}",
      if (length(classes) > class_connector) "Inherits from: {.cls {tail(classes, -class_connector)}}",
      if (length(links)) {
        c(
          "Registered methods:",
          rlang::set_names(links, "*")
        )
      },
      if (length(specs)) {
        c(
          "Specifications:",
          paste0(names(specs), ": ", specs) |>
            rlang::set_names("*")
        )
      }
    )
  )

  return(invisible(connector_object))
}
