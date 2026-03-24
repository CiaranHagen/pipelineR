#' Yahooquery
#' Queries the yahoo db for stock prices up until yesterday
#' and then extracts the latest stock price for each item.
#'
#' @param batch
#'
#' @returns df("latest stock prices")
#' @export
#'
#' @examples
yahoo_query_data <- function(batch) {

  data <- tidyquant::tq_get(batch,
                        get  = "stock.prices",
                        from = "2000-01-01",
                        to   = Sys.Date()-1)

  batchComplete <- data %>%
      group_by(symbol) %>%
      slice_max(date, n = 1, with_ties = FALSE) %>%
      ungroup()

  return(batchComplete)
}
