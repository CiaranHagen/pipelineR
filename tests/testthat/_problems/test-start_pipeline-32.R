# Extracted from test-start_pipeline.R:32

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
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
