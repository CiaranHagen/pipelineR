# Extracted from test-format_data.R:112

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con <- structure(list(), class = "PqConnection")
db <- tibble::tibble(
    symbol   = c("AAPL", "MSFT"),
    date     = as.Date(c("2024-01-01", "2024-01-01")),
    open     = c(180, 400),
    high     = c(185, 405),
    low      = c(178, 398),
    close    = c(183, 402),
    volume   = c(5e7, 3e7),
    adjusted = c(183, 402)
  )
call_count <- 0L
mockery::stub(format_data, "glue::glue_sql", "SELECT index_ts FROM sp500.info WHERE symbol = 'X';")
