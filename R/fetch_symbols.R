#' Fetch symbols
#' Fetches all company symbols from the db.
#'
#' @param con
#'
#' @returns
#' @export
#'
#' @examples
fetch_symbols <- function(con) {
  symbols <- DBI::dbGetQuery(con, "SELECT symbol FROM sp500.info;")
  return(unique(symbols))
}
