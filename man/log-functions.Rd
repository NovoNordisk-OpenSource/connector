% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/logger_generics.R, R/logger_log_dbi.R,
%   R/logger_log_fs.R
\name{log-functions}
\alias{log-functions}
\alias{log_read_connector}
\alias{log_read_connector.default}
\alias{log_write_connector}
\alias{log_write_connector.default}
\alias{log_remove_connector}
\alias{log_remove_connector.default}
\alias{log_list_content_connector}
\alias{log_read_connector.ConnectorDBI}
\alias{log_write_connector.ConnectorDBI}
\alias{log_remove_connector.ConnectorDBI}
\alias{log_read_connector.ConnectorFS}
\alias{log_write_connector.ConnectorFS}
\alias{log_remove_connector.ConnectorFS}
\title{Connector Logging Functions}
\usage{
log_read_connector(connector_object, name, ...)

\method{log_read_connector}{default}(connector_object, name, ...)

log_write_connector(connector_object, name, ...)

\method{log_write_connector}{default}(connector_object, name, ...)

log_remove_connector(connector_object, name, ...)

\method{log_remove_connector}{default}(connector_object, name, ...)

log_list_content_connector(connector_object, ...)

\method{log_read_connector}{ConnectorDBI}(connector_object, name, ...)

\method{log_write_connector}{ConnectorDBI}(connector_object, name, ...)

\method{log_remove_connector}{ConnectorDBI}(connector_object, name, ...)

\method{log_read_connector}{ConnectorFS}(connector_object, name, ...)

\method{log_write_connector}{ConnectorFS}(connector_object, name, ...)

\method{log_remove_connector}{ConnectorFS}(connector_object, name, ...)
}
\arguments{
\item{connector_object}{The connector object to log operations for. Can be
any connector class (ConnectorFS, ConnectorDBI, ConnectorLogger, etc.)}

\item{name}{Character string specifying the name or identifier of the
resource being operated on (e.g., file name, table name)}

\item{...}{Additional parameters passed to specific method implementations.
May include connector-specific options or metadata.}
}
\value{
These are primarily side-effect functions that perform logging. The actual
return value depends on the specific method implementation, typically:
\itemize{
\item \code{log_read_connector}: Result of the read operation
\item \code{log_write_connector}: Invisible result of write operation
\item \code{log_remove_connector}: Invisible result of remove operation
\item \code{log_list_content_connector}: List of connector contents
}
}
\description{
A comprehensive set of generic functions and methods for logging connector
operations. These functions provide automatic logging capabilities for read,
write, remove, and list operations across different connector types, enabling
transparent audit trails and operation tracking.
}
\details{
Connector Logging Functions

The logging system is built around S3 generic functions that dispatch to
specific implementations based on the connector class. Each operation is
logged with contextual information including connector details, operation
type, and resource names.
}
\section{Available Operations}{

\describe{
\item{\code{log_read_connector(connector_object, name, ...)}}{
Logs read operations when data is retrieved from a connector.
Automatically called by \code{read_cnt()} and \code{tbl_cnt()} methods.
}
\item{\code{log_write_connector(connector_object, name, ...)}}{
Logs write operations when data is stored to a connector.
Automatically called by \code{write_cnt()} and \code{upload_cnt()} methods.
}
\item{\code{log_remove_connector(connector_object, name, ...)}}{
Logs removal operations when resources are deleted from a connector.
Automatically called by \code{remove_cnt()} methods.
}
\item{\code{log_list_content_connector(connector_object, ...)}}{
Logs listing operations when connector contents are queried.
Automatically called by \code{list_content_cnt()} methods.
}
}
}

\section{Supported Connector Types}{

Each connector type has specialized logging implementations:
\describe{
\item{\strong{ConnectorFS}}{
File system connectors log the full file path and operation type.
Example log: \code{"dataset.csv @ /path/to/data"}
}
\item{\strong{ConnectorDBI}}{
Database connectors log driver information and database name.
Example log: \code{"table_name @ driver: SQLiteDriver, dbname: mydb.sqlite"}
}
}
}

\section{Integration with whirl Package}{

All logging operations use the \pkg{whirl} package for consistent log output:
\itemize{
\item \code{whirl::log_read()} - For read operations
\item \code{whirl::log_write()} - For write operations
\item \code{whirl::log_delete()} - For remove operations
}
}

\examples{
# Basic usage with file system connector
logged_fs <- add_logs(connectors(data = connector_fs(path = tempdir())))

# Write operation (automatically logged)
write_cnt(logged_fs$data, mtcars, "cars.csv")
# Output: "cars.csv @ /tmp/RtmpXXX"

#' # Read operation (automatically logged)
data <- read_cnt(logged_fs$data, "cars.csv")
# Output: "dataset.csv @ /tmp/RtmpXXX"

# Database connector example
logged_db <- add_logs(connectors(db = connector_dbi(RSQLite::SQLite(), ":memory:")))

# Operations are logged with database context
write_cnt(logged_db$db, iris, "iris_table")
# Output: "iris_table @ driver: SQLiteDriver, dbname: :memory:"

}
\seealso{
\code{\link{add_logs}} for adding logging capability to connectors,
\code{\link{ConnectorLogger}} for the logger class,
\pkg{whirl} package for underlying logging implementation
}
