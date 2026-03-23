start_pipeline <- function() {
  db <- connect_db()
  symbols <- fetch_symbols(db)

  #build_summary_table()

  output <- split_batch(symbols)
  batches <- output[[1]]
  nrows <- length(unique(output[[2]]))

  #for each batch:
  allBatches <- tibble()

  for (i in 1:2) { #1:nrows
    batch <- batches[[i]]
    batch <- yahoo_query_data(batch)
    rbind(allBatches, batch)
  }

  format_data()
  #insert_new_data()
  #log_summary()

  #push_summary_table()
  #dbDisconnect()
}
