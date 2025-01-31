% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cnt_generics.R, R/dbi_methods.R, R/fs_methods.R
\name{write_cnt}
\alias{write_cnt}
\alias{write_cnt.connector_dbi}
\alias{write_cnt.connector_fs}
\title{Write content to the connector}
\usage{
write_cnt(connector_object, x, name, ...)

\method{write_cnt}{connector_dbi}(connector_object, x, name, overwrite = TRUE, ...)

\method{write_cnt}{connector_fs}(connector_object, x, name, ...)
}
\arguments{
\item{connector_object}{\link{connector} The connector object to use.}

\item{x}{The object to write to the connection}

\item{name}{\link{character} Name of the content to read, write, or remove. Typically the table name.}

\item{...}{Additional arguments passed to the method for the individual connector.}

\item{overwrite}{By default set to TRUE, in order to allow interchangeability between how
\code{connector_fs} works and \code{connector_dbi}.}
}
\value{
\link{invisible} connector_object.
}
\description{
Generic implementing of how to write content to the different connector objects:

\itemize{
\item \link{connector_dbi}: Uses \code{\link[DBI:dbWriteTable]{DBI::dbWriteTable()}} to write the table to the DBI connection.
}

\itemize{
\item \link{connector_fs}: Uses \code{\link[=write_file]{write_file()}} to Write a file based on the file extension.
The underlying function used, and thereby also the arguments available
through \code{...} depends on the file extension.
}
}
\examples{
# Write table to DBI database
cnt <- connector_dbi$new(RSQLite::SQLite())

cnt |>
  list_content_cnt()

cnt |>
  write_cnt(iris, "iris")

cnt |>
  list_content_cnt()

# Write different file types to a file storage
cnt <- connector_fs$new(tempdir())

cnt |>
  list_content_cnt(pattern = "iris")

# rds file
cnt |>
  write_cnt(iris, "iris.rds")

# CSV file
cnt |>
  write_cnt(iris, "iris.csv")

cnt |>
  list_content_cnt(pattern = "iris")

}
