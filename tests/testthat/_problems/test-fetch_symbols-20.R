# Extracted from test-fetch_symbols.R:20

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con  <- structure(list(), class = "PqConnection")
mock_data <- tibble::tibble(symbol = c("AAPL", "MSFT", "AAPL", "GOOGL", "MSFT"))
mockery::stub(fetch_symbols, "DBI::dbGetQuery", mock_data)
