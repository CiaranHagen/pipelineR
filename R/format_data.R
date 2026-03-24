#' Format Data
#' Converts the new data into the same format as the target db.
#'
#' @param db
#' @param con
#'
#' @returns df(newDB)
#' @export
#'
#' @examples
format_data <- function(db, con) {
  newDB <- tibble(
            index_ts = '',
            date = as.Date(x = integer(0), origin = "2000-01-01"),
            metric = '',
            value = 0
           )[0,]

  numRows <- nrow(db)
  for (i in 1:numRows) {
    #print(i / numRows)

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
