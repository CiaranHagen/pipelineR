start_pipeline <- function() {
  db <- connect_db()
  symbols <- fetch_symbols(db)

  #build_summary_table()
  output <- split_batch(symbols)
  batches <- output[[0]]
  nrows <- output[[1]]

  #for each batch:
  for (i in 1:nrows) {
    batch <- batches[[i]]
    batch
    print("---")
    # yahoo_query_data()
  }

  #format_data()
  #insert_new_data()
  #log_summary()

  #push_summary_table()
  #dbDisconnect()
}
