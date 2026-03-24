format_data <- function(db, con) {
  newDB <- tibble(
            index_ts = '',
            date = as.Date(x = integer(0), origin = "2000-01-01"),
            metric = '',
            value = 0,
            id = double()
           )[0,]
  numRows <- nrow(db)
  for (i in 1:numRows) {
    print(i / numRows)
    row <- db %>% slice(1)
    symbol <- row$symbol

    index_ts_query <- capture.output(cat("SELECT index_ts FROM sp500.info WHERE symbol = '", symbol, "';", sep = ""))
    index_ts <- DBI::dbGetQuery(con, index_ts_query)[[1]]

    date <- lubridate::ymd(row[["date"]][[1]])
    id_query <- glue::glue_sql("
                        SELECT id FROM sp500.data
                        WHERE index_ts = {index_ts}
                        AND date = {date};
                      ", .con = con)
    id_df <- DBI::dbGetQuery(con, id_query)
    id <- as.double(id_df[[1]])
    cat(symbol, index_ts, id)
    # index_ts, date, metric, value, id
    newDB <- newDB %>%
      add_row(index_ts = index_ts, date = row$date, metric = "open",     value = row$open,     id = id) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "high",     value = row$high,     id = id) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "low",      value = row$low,      id = id) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "close",    value = row$close,    id = id) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "volume",   value = row$volume,   id = id) %>%
      add_row(index_ts = index_ts, date = row$date, metric = "adjusted", value = row$adjusted, id = id)
  }
  return(newDB)
}
