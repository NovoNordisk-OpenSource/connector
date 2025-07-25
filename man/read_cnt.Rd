% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cnt_generics.R, R/dbi_methods.R,
%   R/fs_methods.R, R/logger_generics.R
\name{read_cnt}
\alias{read_cnt}
\alias{read_cnt.ConnectorDBI}
\alias{read_cnt.ConnectorFS}
\alias{read_cnt.ConnectorLogger}
\title{Read content from the connector}
\usage{
read_cnt(connector_object, name, ...)

\method{read_cnt}{ConnectorDBI}(connector_object, name, ...)

\method{read_cnt}{ConnectorFS}(connector_object, name, ...)

\method{read_cnt}{ConnectorLogger}(connector_object, name, ...)
}
\arguments{
\item{connector_object}{\link{Connector} The connector object to use.}

\item{name}{\link{character} Name of the content to read, write, or remove. Typically the table name.}

\item{...}{Additional arguments passed to the method for the individual connector.}
}
\value{
R object with the content. For rectangular data a \link{data.frame}.
}
\description{
Generic implementing of how to read content from the different connector objects:

\itemize{
\item \link{ConnectorDBI}: Uses \code{\link[DBI:dbReadTable]{DBI::dbReadTable()}} to read the table from the DBI connection.
}

\itemize{
\item \link{ConnectorFS}: Uses \code{\link[=read_file]{read_file()}} to read a given file.
The underlying function used, and thereby also the arguments available
through \code{...} depends on the file extension.
}

\itemize{
\item \link{ConnectorLogger}: Logs the read operation and calls the underlying connector method.
}
}
\examples{
# Read table from DBI database
cnt <- connector_dbi(RSQLite::SQLite())

cnt |>
  write_cnt(iris, "iris")

cnt |>
  list_content_cnt()

cnt |>
  read_cnt("iris") |>
  head()

# Write and read a CSV file using the file storage connector

folder <- withr::local_tempdir()
cnt <- connector_fs(folder)

cnt |>
  write_cnt(iris, "iris.csv")

cnt |>
  read_cnt("iris.csv") |>
  head()

# Add logging to a file system connector
folder <- withr::local_tempdir()
cnt <- connectors(data = connector_fs(folder)) |> add_logs()

cnt$data |>
  write_cnt(iris, "iris.csv")

cnt$data |>
  read_cnt("iris.csv") |>
  head()

}
