#' Format Stock Data to Long Format for Database
#' @return A tibble with columns:
#' @importFrom dplyr slice add_row
#' @importFrom tibble tibble
#'
#' @export
#'
#' @examples

library(dplyr)
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
