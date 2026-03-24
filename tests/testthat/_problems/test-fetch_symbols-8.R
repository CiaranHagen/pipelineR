# Extracted from test-fetch_symbols.R:8

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con  <- structure(list(), class = "PqConnection")
mock_data <- tibble::tibble(symbol = c("AAPL", "MSFT", "GOOGL"))
mockery::stub(fetch_symbols, "DBI::dbGetQuery", function(con, query) {
    expect_match(query, "sp500\\.info")
    mock_data
  })
