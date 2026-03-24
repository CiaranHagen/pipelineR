# Extracted from test-push_summary_table.R:8

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con       <- structure(list(), class = "PqConnection")
captured_table <- NULL
captured_data  <- NULL
log <- pipelineR:::build_summary_table()
mockery::stub(pipelineR:::push_summary_table, "DBI:::dbAppendTable", ...)
