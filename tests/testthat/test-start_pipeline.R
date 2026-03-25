test_that("start_pipeline connects to the database, runs the pipeline, and disconnects", {
  mock_con <- structure(list(), class = "PqConnection")

  mock_symbols <- tibble::tibble(symbol = c("AAPL", "MSFT"))

  mock_batch_output <- list(
    batches = list(mock_symbols),
    nrows   = 1L
  )

  mock_raw_data <- tibble::tibble(
    symbol   = c("AAPL", "MSFT"),
    date     = as.Date(c("2024-01-02", "2024-01-02")),
    open     = c(185, 400), high  = c(188, 405),
    low      = c(184, 398), close = c(187, 402),
    volume   = c(5e7, 3e7), adjusted = c(187, 402)
  )

  mock_formatted <- tibble::tibble(
    index_ts = rep(c("idx_aapl", "idx_msft"), each = 6),
    date     = rep(as.Date("2024-01-02"), 12),
    metric   = rep(c("open", "high", "low", "close", "volume", "adjusted"), 2),
    value    = c(185, 188, 184, 187, 5e7, 187, 400, 405, 398, 402, 3e7, 402)
  )

  mock_inserted <- mock_formatted

  mock_log <- pipelineR:::build_summary_table()

  disconnect_called <- FALSE

  mockery::stub(start_pipeline, "connect_db",          mock_con)
  mockery::stub(start_pipeline, "fetch_symbols",        mock_symbols)
  mockery::stub(start_pipeline, "split_batch",          mock_batch_output)
  mockery::stub(start_pipeline, "yahoo_query_data",     mock_raw_data)
  mockery::stub(start_pipeline, "format_data",          mock_formatted)
  mockery::stub(start_pipeline, "insert_new_data",      mock_inserted)
  mockery::stub(start_pipeline, "build_summary_table",  mock_log)
  mockery::stub(start_pipeline, "log_summary",          mock_log)
  mockery::stub(start_pipeline, "push_summary_table",   invisible(NULL))
  mockery::stub(start_pipeline, "DBI::dbDisconnect",    function(con) {
    disconnect_called <<- TRUE
    invisible(NULL)
  })

  batch_size <- 25

  result <- start_pipeline(batch_size)

  expect_true(disconnect_called)
  expect_identical(result, mock_inserted)
})
