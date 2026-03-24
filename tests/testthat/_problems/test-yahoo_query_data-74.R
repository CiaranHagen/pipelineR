# Extracted from test-yahoo_query_data.R:74

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# prequel ----------------------------------------------------------------------
with_nrows <- function(n, code) {
  ns <- getNamespace("pipelineR")
  had_nrows <- exists("nrows", envir = ns, inherits = FALSE)
  old_val   <- if (had_nrows) get("nrows", envir = ns) else NULL
  tryCatch({
    if (bindingIsLocked(name, ns)) unlockBinding(name, ns)
    assign("nrows", n, envir = ns)
    lockBinding("nrows", ns)
  }, finally = {
    assign("nrows", n, envir = ns)
  })

  on.exit({
    if (had_nrows) {
      tryCatch({
        if (bindingIsLocked(name, ns)) unlockBinding(name, ns)
        assign("nrows", n, envir = ns)
        lockBinding("nrows", ns)
      }, finally = {
        assign("nrows", n, envir = ns)
      })
    }
    else           remove("nrows", envir = ns)
  }, add = TRUE)
  force(code)
}

# test -------------------------------------------------------------------------
batch   <- tibble::tibble(symbol = "AAPL")
batches <- list(batch)
mock_prices <- tibble::tibble(
    symbol   = c("AAPL", "AAPL", "AAPL"),
    date     = as.Date(c("2024-01-01", "2024-01-03", "2024-01-02")),
    open     = c(180.0, 190.0, 185.0),
    high     = c(183.0, 193.0, 188.0),
    low      = c(179.0, 189.0, 184.0),
    close    = c(182.0, 192.0, 187.0),
    volume   = c(5e7, 5.2e7, 5.1e7),
    adjusted = c(182.0, 192.0, 187.0)
  )
mockery::stub(yahoo_query_data, "tidyquant::tq_get", mock_prices)
result <- with_nrows(1L, yahoo_query_data(batches))
