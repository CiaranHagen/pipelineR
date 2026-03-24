fetch_symbols <- function(con) {
  symbols <- DBI::dbGetQuery(con, "SELECT symbol FROM sp500.info;")
  return(symbols)
}
