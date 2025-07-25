% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connect.R
\name{connect}
\alias{connect}
\title{Connect to datasources specified in a config file}
\usage{
connect(
  config = "_connector.yml",
  metadata = NULL,
  datasource = NULL,
  set_env = TRUE,
  logging = zephyr::get_option("logging", "connector")
)
}
\arguments{
\item{config}{\link{character} path to a connector config file or a \link{list} of specifications}

\item{metadata}{\link{list} Replace, add or create elements to the metadata field found in config}

\item{datasource}{\link{character} Name(s) of the datasource(s) to connect to.
If \code{NULL} (the default) all datasources are connected.}

\item{set_env}{\link{logical} Should environment variables from the yaml file be set? Default is TRUE.}

\item{logging}{Add logs to the console as well as to the whirl log html files. Default: \code{FALSE}.}
}
\value{
\link{connectors}
}
\description{
Based on a configuration file or list this functions creates a \code{\link[=connectors]{connectors()}} object with
a \link{Connector} for each of the specified datasources.

The configuration file can be in any format that can be read through \code{\link[=read_file]{read_file()}}, and
contains a list. If a yaml file is provided, expressions are evaluated when parsing it
using \code{\link[yaml:read_yaml]{yaml::read_yaml()}} with \code{eval.expr = TRUE}.

See also \code{vignette("connector")} on how to use configuration files in your project,
details below for the required structure of the configuration.
}
\details{
The input list can be specified in two ways:
\enumerate{
\item A named list containing the specifications of a single \link{connectors} object.
\item An unnamed list, where each element is of the same structure as in 1., which
returns a nested \link{connectors} object. See example below.
}

Each specification of a single \link{connectors}  have to have the following structure:
\itemize{
\item Only name, metadata, env and datasources are allowed.
\item All elements must be named.
\item \strong{name} is only required when using nested connectors.
\item \strong{datasources} is mandatory.
\item \strong{metadata} and \strong{env} must each be a list of named character vectors of length 1 if specified.
\item \strong{datasources} must each be a list of unnamed lists.
\item Each datasource must have the named character element \strong{name} and the named list element \strong{backend}
\item For each connection \strong{backend}.\strong{type} must be provided
}
}
\examples{
withr::with_tempdir({
# Create dir for the example in tmpdir
dir.create("example/demo_trial/adam", recursive = TRUE)

config <- system.file("config", "_connector.yml", package = "connector")

config

# Show the raw configuration file
readLines(config) |>
  cat(sep = "\n")

# Connect to the datasources specified in it
cnts <- connect(config)
cnts

# Content of each connector

cnts$adam
cnts$sdtm

# Overwrite metadata informations

connect(config, metadata = list(extra_class = "my_class"))

# Connect only to the adam datasource

connect(config, datasource = "adam")

# Connect to several projects in a nested structure

config_nested <- system.file("config", "_nested_connector.yml", package = "connector")

readLines(config_nested) |>
  cat(sep = "\n")

cnts_nested <- connect(config_nested)

cnts_nested

cnts_nested$study1

})
}
