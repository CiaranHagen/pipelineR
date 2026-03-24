#' Build an Empty Pipeline Summary Log Tibble
#'
#' Creates an empty tibble that serves as a log container for recording the
#' outcome of each batch in the stock data pipeline. Each row in the resulting
#' tibble represents a single pipeline batch event.
#'
#' @return An empty tibble with the following columns:
#'   \itemize{
#'     \item \code{user_login} (character): The database username that ran the pipeline
#'     \item \code{batch_id} (numeric): Identifier for the batch being processed
#'     \item \code{symbol} (character): The stock ticker symbol
#'     \item \code{status} (character): Outcome of the batch (e.g., \code{"OK"} or \code{"ERROR"})
#'     \item \code{n_rows} (numeric): Number of rows inserted for this batch
#'     \item \code{message} (character): A descriptive message about the batch result
#'     \item \code{timestamp} (Date): The date on which the batch was processed
#'   }
#'
#' @seealso
#' \code{\link{log_summary}} for populating the tibble,
#' \code{\link{push_summary_table}} for writing the log to the database
#'
#' @importFrom tibble tibble
#'
#' @export
#'
#' @examples
#' log <- build_summary_table()
#' nrow(log)  # 0 — the tibble is empty
#' colnames(log)



build_summary_table <- function() {
  logTibble <- tibble(
    user_login = '',
    batch_id = 0,
    symbol = '',
    status = '',
    n_rows = 0,
    message = '',
    timestamp = as.Date(x = integer(0), origin = "2000-01-01")
  )[0,]

  return(logTibble)
}
