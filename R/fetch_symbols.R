#' Fetch S&P 500 Stock Symbols from Database
#'
#' Retrieves all unique stock ticker symbols from the sp500.info table.
#'
#' This function executes a SQL query to fetch all stock symbols from the database
#' and returns only unique values to prevent duplicate processing.
#'
#' @param con A DBI connection object created by \code{\link{connect_db}}.
#'
#' @return A tibble with a single column named \code{symbol} containing unique
#'   stock ticker symbols (e.g., "AAPL", "MSFT", "GOOGL").
#'
#' @details
#' The function executes the SQL query: \code{SELECT symbol FROM sp500.info;}
#' and applies \code{unique()} to remove any duplicate symbols.
#'
#' @seealso
#' \code{\link{connect_db}} for creating the database connection,
#' \code{\link{split_batch}} for processing symbols in batches
#'
#' @importFrom DBI dbGetQuery
#'
#' @export
#'
#' @examples
#' \dontrun{
#' con <- connect_db()
#' symbols <- fetch_symbols(con)
#' head(symbols)
#' nrow(symbols)  # Total number of unique symbols
#' DBI::dbDisconnect(con)
#' }
fetch_symbols <- function(con) {
  symbols <- DBI::dbGetQuery(con, "SELECT symbol FROM sp500.info;")
  return(unique(symbols))
}
