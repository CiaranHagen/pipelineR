start_pipeline <- function() {
  db <- connect_db()
  symbols <- fetch_symbols(db)

  #build_summary_table()

  output <- split_batch(symbols)
  batches <- output[[1]]
  nrows <- length(unique(output[[2]]))


  #for each batch:
  allBatches <- yahoo_query_data(batches[[1]])

  for (i in 2:nrows) {
    batch <- batches[[i]]
    #print(batch)
    #print("---")
    batch <- yahoo_query_data(batch)
    print(batch)
    rbind(allBatches, batch)
    print(allBatches)
  }

  format_data()
  #insert_new_data()
  #log_summary()

  #push_summary_table()
  #dbDisconnect()
}
