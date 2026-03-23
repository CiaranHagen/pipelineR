

symbols <- DBI::dbGetQuery(db, "SELECT index_ts FROM sp500.info WHERE symbol = 'URI';")
