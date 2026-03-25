#' Format Stock Data to Long Format for Database
#'
#' Converts wide-format stock data into long-format for database insertion.
#'
#' This function performs a wide-to-long transformation, converting individual
#' price columns (open, high, low, close, volume, adjusted) into a single
#' metric column with corresponding values. It also looks up the \code{index_ts}
#' identifier for each symbol from the database.
#'
#' @param db A tibble containing raw stock price data with columns:
#'   \code{symbol}, \code{date}, \code{open}, \code{high}, \code{low},
#'   \code{close}, \code{volume}, and \code{adjusted}.
#'
#' @param con A DBI connection object created by \code{\link{connect_db}}.
#'   This is used to query the sp500.info table for symbol index timestamps.
#'
#' @return A tibble with columns:
#'   \itemize{
#'     \item \code{index_ts}: The symbol's internal index timestamp
#'     \item \code{date}: The date of the stock price
#'     \item \code{metric}: The type of metric (open, high, low, close, volume, adjusted)
#'     \item \code{value}: The numeric value of the metric
#'   }
#'
#' @details
#' For each input row, the function creates 6 new rows (one per metric).
#' A dataset with 1000 stock prices will have 6000 rows in the output.
#'
#' Progress is displayed to the console as rows are processed (e.g., "42 / 500").
#'
#' @seealso
#' \code{\link{yahoo_query_data}} for obtaining the input data,
#' \code{\link{insert_new_data}} for loading the output into the database
#'
#' @importFrom dplyr slice add_row
#' @importFrom glue glue_sql
#' @importFrom tibble tibble
#' @importFrom DBI dbGetQuery
#'
#' @export
#'
#' @examples
#' \dontrun{
#' con <- connect_db()
#' # Assume 'db' contains wide-format stock data
#' formatted <- format_data(db, con)
#' head(formatted)
#' # Each input row becomes 6 rows in the output
#' DBI::dbDisconnect(con)
#' }

format_data <- function(db, con) {
  newDB <- tibble(
            index_ts = '',
            date = as.Date(x = integer(0), origin = "2000-01-01"),
            metric = '',
            value = 0
           )[0,]

  numRows <- nrow(db)
  for (i in 1:numRows) {
    cat("\r  ", i, "/", numRows)

    row <- db %>% slice(i)

    symbol <- row$symbol

    index_ts_query <- glue::glue_sql("
                              SELECT index_ts FROM sp500.info
                              WHERE symbol = {symbol};
                            ", .con = con)
    index_ts <- DBI::dbGetQuery(con, index_ts_query)[[1]]

    # index_ts, date, metric, value, id
    newDB <- newDB %>%
      add_row(index_ts = index_ts, date = row$date, metric = "open",     value = row$open    ) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "high",     value = row$high    ) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "low",      value = row$low     ) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "close",    value = row$close   ) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "volume",   value = row$volume  ) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "adjusted", value = row$adjusted)
  }
  return(newDB)
}
