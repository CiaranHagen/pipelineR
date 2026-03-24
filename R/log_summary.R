#' Append a Batch Result to the Pipeline Summary Log
#'
#' Records the outcome of processing a single batch of stock data by appending
#' a new row to the provided log tibble.  The row captures whether new data was
#' inserted successfully and includes the number of rows and a short message.
#'
#' @param logTibble A tibble created by \code{\link{build_summary_table}} (or one
#'   that was previously returned by this function) into which the new log entry
#'   will be appended.
#'
#' @param finalDB A tibble containing the rows that were inserted into the
#'   database for this batch (typically the return value of
#'   \code{\link{insert_new_data}}).  An empty tibble indicates that no new
#'   rows were written and the status will be set to \code{"ERROR"}.
#'
#' @param user A character string identifying the database username (e.g., the
#'   value of \code{Sys.getenv("PG_USER")}).
#'
#' @return A tibble with the same structure as \code{logTibble} but with one
#'   additional row (or more if \code{finalDB} contains multiple symbols)
#'   representing the current batch result.  Duplicate rows are removed before
#'   returning.
#'
#' @seealso
#' \code{\link{build_summary_table}} to create the initial empty log tibble,
#' \code{\link{push_summary_table}} for writing the completed log to the database
#'
#' @importFrom dplyr add_row
#' @importFrom tibble tibble
#'
#' @export
#'
#' @examples
#' \dontrun{
#' log <- build_summary_table()
#' log <- log_summary(log, inserted_data, Sys.getenv("PG_USER"))
#' }

log_summary <- function(logTibble, finalDB, user) {
  # user_login, batch_id, symbol, status, n_rows, message, timestamp
    numRows <- nrow(finalDB)
    if (numRows>0) {
      status <- "OK"
      message <- capture.output(cat(numRows, "lines inserted."))
    } else {
      status <- "ERROR"
      message <- "No lines inserted."
    }

    logTibble <- logTibble %>%
      add_row(user_login = user, batch_id = 0, symbol = finalDB$index_ts, status = status, n_rows = nrow(finalDB), message = message, timestamp = Sys.Date())
    return(unique(logTibble))
}
