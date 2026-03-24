#' Push the Pipeline Summary Log to the Database
#'
#' Appends the completed pipeline summary log tibble to the
#' \code{pipeline_logs} table in the database.
#'
#' @param db A log summary tibble containing one or more log rows, typically
#'   the object returned by \code{\link{log_summary}} after processing all
#'   batches.
#'
#' @param con A DBI connection object created by \code{\link{connect_db}}.
#'   The connection must have write privileges on the \code{pipeline_logs} table.
#'
#' @return The number of rows appended (returned invisibly by
#'   \code{DBI::dbAppendTable}).
#'
#' @seealso
#' \code{\link{build_summary_table}} for creating the initial log tibble,
#' \code{\link{log_summary}} for populating it,
#' \code{\link{connect_db}} for creating the database connection
#'
#' @importFrom DBI dbAppendTable
#'
#' @export
#'
#' @examples
#' \dontrun{
#' con <- connect_db()
#' log <- build_summary_table()
#' log <- log_summary(log, inserted_data, Sys.getenv("PG_USER"))
#' push_summary_table(log, con)
#' DBI::dbDisconnect(con)
#' }
push_summary_table <- function(db, con) {
  DBI::dbAppendTable(con, "pipeline_logs", db)
}
