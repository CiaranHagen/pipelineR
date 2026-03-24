test_that("fetch_symbols queries the sp500.info table and returns a tibble", {
  mock_con  <- structure(list(), class = "PqConnection")
  mock_data <- tibble::tibble(symbol = c("AAPL", "MSFT", "GOOGL"))

  mockery::stub(fetch_symbols, "DBI::dbGetQuery", function(con, query) {
    expect_match(query, "sp500\\.info")
    mock_data
  })

  result <- fetch_symbols(mock_con)
  expect_s3_class(result, "data.frame")
  expect_true("symbol" %in% colnames(result))
})

test_that("fetch_symbols deduplicates symbols", {
  mock_con  <- structure(list(), class = "PqConnection")
  # Return data with duplicate symbols
  mock_data <- tibble::tibble(symbol = c("AAPL", "MSFT", "AAPL", "GOOGL", "MSFT"))

  mockery::stub(fetch_symbols, "DBI::dbGetQuery", mock_data)

  result <- fetch_symbols(mock_con)
  expect_equal(nrow(result), 3)
  expect_equal(sort(result$symbol), c("AAPL", "GOOGL", "MSFT"))
})

test_that("fetch_symbols returns symbols unchanged when there are no duplicates", {
  mock_con  <- structure(list(), class = "PqConnection")
  mock_data <- tibble::tibble(symbol = c("AAPL", "MSFT", "GOOGL"))

  mockery::stub(fetch_symbols, "DBI::dbGetQuery", mock_data)

  result <- fetch_symbols(mock_con)
  expect_equal(nrow(result), 3)
})
