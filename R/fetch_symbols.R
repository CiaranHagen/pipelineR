fetch_symbols <- function(db) {
  symbols <- DBI::dbGetQuery(db, "SELECT symbol FROM sp500.info;")
  return(symbols)
}
