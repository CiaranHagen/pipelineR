#' Orchestrator
#' Orchestrates all of the other functions.
#'
#' @returns nothing.
#' @export
#'
#' @examples
start_pipeline <- function() {
  con <- connect_db()
  symbols <- fetch_symbols(con)

  #build_summary_table()

  output <- split_batch(symbols)
  batches <- output[[1]]
  nrows <- length(unique(output[[2]]))

  #for each batch:
  db <- tibble()
  for (i in 1:2) { #1:nrows
    batch <- batches[[i]]

    batchComplete <- yahoo_query_data(batch)
    db <- rbind(db, batchComplete)
  }

  newDB <- format_data(db, con)
  finalDB <- insert_new_data(newDB, con)

  #log_summary()
  #push_summary_table()
  DBI::dbDisconnect(con)
}
