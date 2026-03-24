test_that("split_batch returns a list with 'batches' and 'nrows' elements", {
  symbols <- tibble::tibble(symbol = paste0("SYM", 1:10))
  result  <- split_batch(symbols)
  expect_type(result, "list")
  expect_named(result, c("batches", "nrows"))
})

test_that("split_batch produces one batch when symbols <= 25", {
  symbols <- tibble::tibble(symbol = paste0("SYM", 1:25))
  result  <- split_batch(symbols)
  expect_equal(result$nrows, 1)
  expect_length(result$batches, 1)
})

test_that("split_batch produces two batches for 26 symbols", {
  symbols <- tibble::tibble(symbol = paste0("SYM", 1:26))
  result  <- split_batch(symbols)
  expect_equal(result$nrows, 2)
  expect_length(result$batches, 2)
  expect_equal(nrow(result$batches[[1]]), 25)
  expect_equal(nrow(result$batches[[2]]), 1)
})

test_that("split_batch handles 57 symbols into three batches of 25, 25, 7", {
  symbols <- tibble::tibble(symbol = paste0("SYM", 1:57))
  result  <- split_batch(symbols)
  expect_equal(result$nrows, 3)
  expect_equal(nrow(result$batches[[1]]), 25)
  expect_equal(nrow(result$batches[[2]]), 25)
  expect_equal(nrow(result$batches[[3]]), 7)
})

test_that("split_batch preserves all symbols without duplication or loss", {
  syms    <- paste0("SYM", 1:57)
  symbols <- tibble::tibble(symbol = syms)
  result  <- split_batch(symbols)
  all_symbols <- unlist(lapply(result$batches, function(b) b$symbol))
  expect_setequal(all_symbols, syms)
})

test_that("split_batch works for a single symbol", {
  symbols <- tibble::tibble(symbol = "AAPL")
  result  <- split_batch(symbols)
  expect_equal(result$nrows, 1)
  expect_equal(nrow(result$batches[[1]]), 1)
})
