# Extracted from test-format_data.R:40

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con <- structure(list(), class = "PqConnection")
db <- tibble::tibble(
    symbol   = "AAPL",
    date     = as.Date("2024-01-02"),
    open     = 185.0,
    high     = 188.5,
    low      = 184.0,
    close    = 187.2,
    volume   = 5e7,
    adjusted = 187.2
  )
mockery::stub(format_data, "glue::glue_sql", "SELECT index_ts FROM sp500.info WHERE symbol = 'AAPL';")
