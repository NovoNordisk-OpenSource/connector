#' Use connector
#'
#' @description
#'
#' Utility function to setup connections with connector in your project:
#'
#' Creates configuration file (default `_connector.yml`)
#'
#' See `vignette("connector")` for how to configure the file.
#'
#' @export

use_connector <- function() {
  cli::cli_h1("Setup {.pkg connector}")

  use_template("readme.yml", config_file = "_connector.yml")

  cli::cli_alert_info(
    "Run {.run connector::connect()} to create connections."
  )

  cli::cli_h1("")

  return(
    invisible(NULL)
  )
}

#' @noRd
use_template <- function(template, config_file) {
  rlang::check_installed("usethis")

  config <- system.file("examples", template, package = "connector") |>
    readLines()

  config_file_path <- usethis::proj_path(config_file)
  usethis::write_over(path = config_file_path, lines = config)
  usethis::edit_file(path = config_file_path)
}
