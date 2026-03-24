# Extracted from test-insert_new_data.R:45

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con <- structure(list(), class = "PqConnection")
existing <- tibble::tibble(
    index_ts = "idx_001",
    date     = as.Date("2024-01-01"),
    metric   = "open",
    value    = 100
  )
new_data <- tibble::tibble(
    index_ts = "idx_001",
    date     = as.Date("2024-01-01"),
    metric   = "open",
    value    = 100
  )
mockery::stub(insert_new_data, "DBI::dbGetQuery",    existing)
