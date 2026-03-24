# Extracted from test-insert_new_data.R:18

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con <- structure(list(), class = "PqConnection")
existing <- tibble::tibble(
    index_ts = c("idx_001", "idx_001"),
    date     = as.Date(c("2024-01-01", "2024-01-01")),
    metric   = c("open", "close"),
    value    = c(100, 102)
  )
new_data <- tibble::tibble(
    index_ts = c("idx_001", "idx_001", "idx_002"),
    date     = as.Date(c("2024-01-01", "2024-01-01", "2024-01-02")),
    metric   = c("open", "close", "open"),
    value    = c(100, 102, 200)
  )
mockery::stub(insert_new_data, "DBI::dbGetQuery",    existing)
