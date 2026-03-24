test_that("format_data converts each input row into 6 long-format rows", {
  mock_con <- structure(list(), class = "PqConnection")

  db <- tibble::tibble(
    symbol   = "AAPL",
    date     = as.Date("2024-01-02"),
    open     = 185.0,
    high     = 188.5,
    low      = 184.0,
    close    = 187.2,
    volume   = 5e7,
    adjusted = 187.2
  )

  # Stub glue_sql so it returns a plain string (no real DB quoting needed)
  mockery::stub(format_data, "glue::glue_sql", "SELECT index_ts FROM sp500.info WHERE symbol = 'AAPL';")

  # Stub dbGetQuery to return a fake index_ts
  mockery::stub(format_data, "DBI::dbGetQuery", data.frame(index_ts = "idx_aapl"))

  result <- format_data(db, mock_con)

  expect_equal(nrow(result), 6)
})

test_that("format_data output contains the correct metric names", {
  mock_con <- structure(list(), class = "PqConnection")

  db <- tibble::tibble(
    symbol   = "AAPL",
    date     = as.Date("2024-01-02"),
    open     = 185.0,
    high     = 188.5,
    low      = 184.0,
    close    = 187.2,
    volume   = 5e7,
    adjusted = 187.2
  )

  mockery::stub(format_data, "glue::glue_sql", "SELECT index_ts FROM sp500.info WHERE symbol = 'AAPL';")
  mockery::stub(format_data, "DBI::dbGetQuery", data.frame(index_ts = "idx_aapl"))

  result <- format_data(db, mock_con)

  expect_setequal(result$metric, c("open", "high", "low", "close", "volume", "adjusted"))
})

test_that("format_data output has the correct column names", {
  mock_con <- structure(list(), class = "PqConnection")

  db <- tibble::tibble(
    symbol   = "AAPL",
    date     = as.Date("2024-01-02"),
    open     = 185.0,
    high     = 188.5,
    low      = 184.0,
    close    = 187.2,
    volume   = 5e7,
    adjusted = 187.2
  )

  mockery::stub(format_data, "glue::glue_sql", "SELECT index_ts FROM sp500.info WHERE symbol = 'AAPL';")
  mockery::stub(format_data, "DBI::dbGetQuery", data.frame(index_ts = "idx_aapl"))

  result <- format_data(db, mock_con)

  expect_named(result, c("index_ts", "date", "metric", "value"))
})

test_that("format_data correctly maps values for each metric", {
  mock_con <- structure(list(), class = "PqConnection")

  db <- tibble::tibble(
    symbol   = "MSFT",
    date     = as.Date("2024-03-01"),
    open     = 400.0,
    high     = 410.0,
    low      = 395.0,
    close    = 405.0,
    volume   = 3e7,
    adjusted = 405.0
  )

  mockery::stub(format_data, "glue::glue_sql", "SELECT index_ts FROM sp500.info WHERE symbol = 'MSFT';")
  mockery::stub(format_data, "DBI::dbGetQuery", data.frame(index_ts = "idx_msft"))

  result <- format_data(db, mock_con)

  expect_equal(result$value[result$metric == "open"],     400.0)
  expect_equal(result$value[result$metric == "high"],     410.0)
  expect_equal(result$value[result$metric == "low"],      395.0)
  expect_equal(result$value[result$metric == "close"],    405.0)
  expect_equal(result$value[result$metric == "volume"],   3e7)
  expect_equal(result$value[result$metric == "adjusted"], 405.0)
})

test_that("format_data scales to multiple input rows (2 rows → 12 output rows)", {
  mock_con <- structure(list(), class = "PqConnection")

  db <- tibble::tibble(
    symbol   = c("AAPL", "MSFT"),
    date     = as.Date(c("2024-01-01", "2024-01-01")),
    open     = c(180, 400),
    high     = c(185, 405),
    low      = c(178, 398),
    close    = c(183, 402),
    volume   = c(5e7, 3e7),
    adjusted = c(183, 402)
  )

  call_count <- 0L
  mockery::stub(format_data, "glue::glue_sql", "SELECT index_ts FROM sp500.info WHERE symbol = 'X';")
  mockery::stub(format_data, "DBI::dbGetQuery", function(con, query) {
    call_count <<- call_count + 1L
    data.frame(index_ts = paste0("idx_", call_count))
  })

  result <- format_data(db, mock_con)

  expect_equal(nrow(result), 12)
})
