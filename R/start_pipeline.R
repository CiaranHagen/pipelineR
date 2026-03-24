#' Orchestrator
#' Orchestrates all of the other functions.
#'
#' @returns nothing.
#' @export
#'
#' @examples
start_pipeline <- function() {
  print("Connecting to db...")
  con <- connect_db()
  print("Fetching symbols...")
  symbols <- fetch_symbols(con)

  #build_summary_table()

  print("Splitting into batches...")
  output <- split_batch(symbols)
  batches <- output[[1]]
  nrows <- length(unique(output[[2]]))

  #for each batch:
  print("Querying additional information for each batch...")
  db <- tibble::tibble()
  for (i in 1:nrows) { #1:nrows
    cat(i, " / ", nrows)
    batch <- batches[[i]]

    batchComplete <- yahoo_query_data(batch)
    db <- rbind(db, batchComplete)
  }
  print("Formating new data...")
  newDB <- format_data(db, con)
  print("Inserting new data into db...")
  finalDB <- insert_new_data(newDB, con)

  #log_summary()
  #push_summary_table()
  DBI::dbDisconnect(con)
}
