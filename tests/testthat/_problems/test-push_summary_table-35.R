# Extracted from test-push_summary_table.R:35

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
mock_con      <- structure(list(), class = "PqConnection")
captured_data <- NULL
log <- pipelineR:::build_summary_table()
mockery::stub(pipelineR:::push_summary_table,
                "get(\"dbAppendTable\", envir = asNamespace(\"DBI\"))",
                function(con, name, value, ...) {
                  captured_data <<- value
                  1L
                })
pipelineR:::push_summary_table(log, mock_con)
