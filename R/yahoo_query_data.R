#' Query Stock Prices from Yahoo Finance
#'
#' Fetches historical stock price data from Yahoo Finance for a batch of symbols.
#'
#' This function queries the Yahoo Finance API via \code{tidyquant::tq_get} to
#' retrieve all daily stock prices from January 1, 2000 through yesterday. For each
#' symbol in the input batch, it extracts only the most recent price record.
#'
#' @param batch A tibble or data frame containing stock symbols to query. Typically
#'   contains a single column named \code{symbol} with ticker symbols (e.g., "AAPL",
#'   "MSFT", "GOOGL").
#'
#' @return A tibble with the most recent stock price data for each symbol. Columns
#'   include:
#'   \itemize{
#'     \item \code{symbol}: The stock ticker symbol
#'     \item \code{date}: The date of the price (most recent for each symbol)
#'     \item \code{open}: Opening price
#'     \item \code{high}: Highest price of the day
#'     \item \code{low}: Lowest price of the day
#'     \item \code{close}: Closing price
#'     \item \code{volume}: Trading volume
#'     \item \code{adjusted}: Adjusted closing price
#'   }
#'
#' @details
#' The function performs these operations:
#' \enumerate{
#'   \item Calls \code{tidyquant::tq_get()} with:
#'     \itemize{
#'       \item \code{get = "stock.prices"}: Retrieves daily stock prices
#'       \item \code{from = "2000-01-01"}: Start date (from year 2000)
#'       \item \code{to = Sys.Date()-1}: End date (up to yesterday)
#'     }
#'   \item Groups results by symbol
#'   \item Selects only the row with the maximum (most recent) date per symbol
#'   \item Removes grouping and returns the result
#' }
#'
#' @seealso
#' \code{\link{split_batch}} for creating batches of symbols,
#' \code{\link{format_data}} for transforming the output,
#' \code{\link[tidyquant]{tq_get}} for the underlying Yahoo Finance API call
#'
#' @importFrom tidyquant tq_get
#' @importFrom dplyr group_by slice_max ungroup
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Create a batch of symbols
#' batch <- tibble::tibble(symbol = c("AAPL", "MSFT", "GOOGL"))
#'
#' # Query the latest prices
#' latest_prices <- yahoo_query_data(batch)
#'
#' # View the results
#' head(latest_prices)
#' dplyr::glimpse(latest_prices)
#' }

yahoo_query_data <- function(batches) {

  nrows <- length(batches)
  db <- tibble::tibble()
  for (i in 1:nrows) { #1:nrows
    cat("\r", i, "/", nrows)
    batch <- batches[[i]]

    data <- tidyquant::tq_get(batch,
                              get  = "stock.prices",
                              from = "2000-01-01")

    batchComplete <- data %>%
      group_by(symbol) %>%
      slice_max(date, n = 1, with_ties = FALSE) %>%
      ungroup()

    db <- rbind(db, batchComplete)
  }

  return(db)
}
