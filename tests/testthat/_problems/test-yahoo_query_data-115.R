# Extracted from test-yahoo_query_data.R:115

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# prequel ----------------------------------------------------------------------
with_nrows <- function(n, code) {
  ns <- getNamespace("pipelineR")
  name <- "nrows"
  had_nrows <- exists(name, envir = ns, inherits = FALSE)
  if (had_nrows) old_val <- get(name, envir = ns)

  # Unlock if locked, assign, then lock
  if (bindingIsLocked(name, ns)) unlockBinding(name, ns)
  assign(name, n, envir = ns)
  lockBinding(name, ns)

  on.exit({
    # Ensure we can modify the binding during cleanup
    if (bindingIsLocked(name, ns)) unlockBinding(name, ns)

    if (had_nrows) {
      assign(name, old_val, envir = ns)
      if (!bindingIsLocked(name, ns)) lockBinding(name, ns)
    } else {
      if (exists(name, envir = ns, inherits = FALSE)) remove(list = name, envir = ns)
    }
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
result <- with_nrows(1L, yahoo_query_data(batches))
