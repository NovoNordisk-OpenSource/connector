% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connector_check_ressource.R
\name{resource-validation}
\alias{resource-validation}
\alias{validate_resource}
\alias{check_resource}
\alias{check_resource.Connector}
\alias{check_resource.ConnectorFS}
\title{Resource Validation System for Connector Objects}
\usage{
validate_resource(x)

check_resource(self)

\method{check_resource}{Connector}(self)

\method{check_resource}{ConnectorFS}(self)
}
\arguments{
\item{x}{Connector object to validate.}

\item{self}{Connector object for method dispatch.}
}
\description{
This module provides a flexible validation system to verify that resources
required by connector objects exist and are accessible. The validation is
performed through S3 method dispatch, allowing each connector class to define
its own validation logic while providing a consistent interface.
}
\section{Architecture}{

The system is built around two main components:
\itemize{
\item \code{validate_resource()}: A dispatcher function that finds and
executes the appropriate S3 method based on the connector's class
\item \code{check_resource()}: A generic S3 method that defines the
validation interface for all connector types
}
}

\section{Method Resolution}{

The validation process follows this hierarchy:
\enumerate{
\item Attempt to find a class-specific method (e.g., \code{check_resource.ConnectorFS})
\item If no specific method exists, fall back to the default \code{check_resource.Connector}
\item Execute the resolved method with appropriate error handling
}
}

\section{Available S3 Methods}{

\describe{
\item{\code{check_resource.Connector}}{Default method that performs no validation.
Serves as a safe fallback for connector classes without specific validation needs.}
\item{\code{check_resource.ConnectorFS}}{Validates file system resources by checking
directory existence using \code{fs::dir_exists()}. Throws informative errors
for missing directories.}
}
}

\section{Implementation Guidelines}{

When implementing new connector classes with resource validation:
\itemize{
\item Define a method following the pattern \code{check_resource.<YourClass>}
\item Return \code{NULL} on successful validation
\item Use \code{cli::cli_abort()} for validation failures to provide consistent error formatting
\item Include \code{call = rlang::caller_env()} in error calls for proper error context
}
}

\section{Error Handling}{

The validation system provides robust error handling:
\itemize{
\item Method resolution failures are handled gracefully with fallback to default
\item Validation errors include contextual information about the failing resource
\item Error messages use \code{cli} formatting for consistency across the package
}
}

\examples{
# Basic validation for a file system connector

fs_connector <- try(ConnectorFS$new(path = "doesn_t_exists"), silent = TRUE)
fs_connector


}
