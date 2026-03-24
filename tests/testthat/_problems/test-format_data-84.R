# Extracted from test-format_data.R:84

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con <- structure(list(), class = "PqConnection")
db <- tibble::tibble(
    symbol   = "MSFT",
    date     = as.Date("2024-03-01"),
    open     = 400.0,
    high     = 410.0,
    low      = 395.0,
    close    = 405.0,
    volume   = 3e7,
    adjusted = 405.0
  )
mockery::stub(format_data, "glue::glue_sql", "SELECT index_ts FROM sp500.info WHERE symbol = 'MSFT';")
