# Extracted from test-log_summary.R:29

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
log     <- pipelineR:::build_summary_table()
finalDB <- tibble::tibble(
    index_ts = character(0),
    date     = as.Date(character(0)),
    metric   = character(0),
    value    = numeric(0)
  )
result <- pipelineR:::log_summary(log, finalDB, user = "test_user")
expect_equal(nrow(result), 0)
expect_equal(result$status, "ERROR")
expect_equal(result$message, "No lines inserted.")
