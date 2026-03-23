fetch_symbols <- function(db) {
  for (i in nrows(db)) {
    symbol <- db[[i]]$symbol
    index_ts_query <- cat("SELECT index_ts,symbol FROM sp500.info WHERE symbol = '", symbol, "';")
    index_ts <- DBI::dbGetQuery(db, index_ts_query)
    id_query <- cat("SELECT id FROM sp500.info WHERE index_ts = '", index_ts,"';")
    id <- DBI::dbGetQuery(db, id_query)

    # Finish this.
  }


  return(symbols)
}
