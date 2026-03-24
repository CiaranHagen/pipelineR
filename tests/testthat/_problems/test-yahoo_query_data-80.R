# Extracted from test-yahoo_query_data.R:80

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
batch1  <- tibble::tibble(symbol = "AAPL")
batch2  <- tibble::tibble(symbol = "MSFT")
batches <- list(batch1, batch2)
call_count <- 0L
mockery::stub(yahoo_query_data, "tidyquant::tq_get", function(batch, get, from) {
    call_count <<- call_count + 1L
    sym <- batch$symbol[1]
    tibble::tibble(
      symbol   = sym,
      date     = as.Date("2024-01-02"),
      open     = 100, high = 105, low = 98,
      close    = 103, volume = 1e6, adjusted = 103
    )
  })
