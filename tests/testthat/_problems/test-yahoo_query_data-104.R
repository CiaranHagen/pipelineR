# Extracted from test-yahoo_query_data.R:104

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

  # If binding exists and is locked, unlock it; otherwise just assign.
  if (exists(name, envir = ns, inherits = FALSE) && bindingIsLocked(name, ns)) {
    unlockBinding(name, ns)
    assign(name, n, envir = ns)
    lockBinding(name, ns)
  } else {
    assign(name, n, envir = ns)
    # lock only if it previously existed and was locked; otherwise keep as default unlocked
  }

  on.exit({
    # Cleanup: if binding exists and is locked, unlock so we can modify/remove it
    if (exists(name, envir = ns, inherits = FALSE) && bindingIsLocked(name, ns)) {
      unlockBinding(name, ns)
    }

    if (had_nrows) {
      assign(name, old_val, envir = ns)
      # restore locked state if desired (best-effort)
      if (!bindingIsLocked(name, ns)) lockBinding(name, ns)
    } else {
      if (exists(name, envir = ns, inherits = FALSE)) remove(list = name, envir = ns)
    }
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
result <- with_nrows(2L, yahoo_query_data(batches))
