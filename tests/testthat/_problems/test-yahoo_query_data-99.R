# Extracted from test-yahoo_query_data.R:99

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# prequel ----------------------------------------------------------------------
with_nrows <- function(n, code) {
  ns <- getNamespace("pipelineR")
  had_nrows <- exists("nrows", envir = ns, inherits = FALSE)
  old_val   <- if (had_nrows) get("nrows", envir = ns) else NULL
  assign("nrows", n, envir = ns)
  on.exit({
    if (had_nrows) assign("nrows", old_val, envir = ns)
    else           remove("nrows", envir = ns)
  }, add = TRUE)
  force(code)
}

# test -------------------------------------------------------------------------
batch   <- tibble::tibble(symbol = "AAPL")
batches <- list(batch)
mock_prices <- tibble::tibble(
    symbol   = "AAPL",
    date     = as.Date("2024-01-02"),
    open     = 185.0, high = 188.0, low = 184.0,
    close    = 187.0, volume = 5e7, adjusted = 187.0
  )
mockery::stub(yahoo_query_data, "tidyquant::tq_get", mock_prices)
