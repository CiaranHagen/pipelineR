# Extracted from test-insert_new_data.R:71

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con <- structure(list(), class = "PqConnection")
new_data <- tibble::tibble(
    index_ts = c("idx_001", "idx_002"),
    date     = as.Date(c("2024-01-01", "2024-01-02")),
    metric   = c("open", "open"),
    value    = c(100, 200)
  )
empty_db <- tibble::tibble(
    index_ts = character(0),
    date     = as.Date(character(0)),
    metric   = character(0),
    value    = numeric(0)
  )
mockery::stub(insert_new_data, "DBI::dbGetQuery",    empty_db)
