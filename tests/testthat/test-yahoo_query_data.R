test_that("yahoo_query_data returns one row per symbol (the most recent date)", {
  batch   <- tibble::tibble(symbol = c("AAPL", "MSFT"))
  batches <- list(batch)

  mock_prices <- tibble::tibble(
    symbol   = c("AAPL", "AAPL", "MSFT"),
    date     = as.Date(c("2024-01-01", "2024-01-02", "2024-01-02")),
    open     = c(180.0, 185.0, 400.0),
    high     = c(183.0, 188.0, 405.0),
    low      = c(179.0, 184.0, 398.0),
    close    = c(182.0, 187.0, 402.0),
    volume   = c(5e7, 5.1e7, 3e7),
    adjusted = c(182.0, 187.0, 402.0)
  )

  mockery::stub(yahoo_query_data, "tidyquant::tq_get", mock_prices)

  result <- yahoo_query_data(batches)

  expect_equal(nrow(result), 2)
  expect_true("AAPL" %in% result$symbol)
  expect_true("MSFT" %in% result$symbol)
})

test_that("yahoo_query_data selects the most recent date per symbol", {
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

  result <- yahoo_query_data(batches)

  expect_equal(nrow(result), 1)
  expect_equal(result$date, as.Date("2024-01-03"))
})

test_that("yahoo_query_data combines results across multiple batches", {
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

  result <- yahoo_query_data(batches)

  expect_equal(call_count, 2L)
  expect_equal(nrow(result), 2)
})

test_that("yahoo_query_data returns a tibble with expected stock price columns", {
  batch   <- tibble::tibble(symbol = "AAPL")
  batches <- list(batch)

  mock_prices <- tibble::tibble(
    symbol   = "AAPL",
    date     = as.Date("2024-01-02"),
    open     = 185.0, high = 188.0, low = 184.0,
    close    = 187.0, volume = 5e7, adjusted = 187.0
  )

  mockery::stub(yahoo_query_data, "tidyquant::tq_get", mock_prices)

  result <- yahoo_query_data(batches)

  expect_true(all(c("symbol", "date", "open", "high", "low",
                    "close", "volume", "adjusted") %in% colnames(result)))
})
