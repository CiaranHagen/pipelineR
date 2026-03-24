test_that("insert_new_data inserts only rows not already in the database", {
  mock_con <- structure(list(), class = "PqConnection")

  existing <- tibble::tibble(
    index_ts = c("idx_001", "idx_001"),
    date     = as.Date(c("2024-01-01", "2024-01-01")),
    metric   = c("open", "close"),
    value    = c(100, 102)
  )

  new_data <- tibble::tibble(
    index_ts = c("idx_001", "idx_001", "idx_002"),
    date     = as.Date(c("2024-01-01", "2024-01-01", "2024-01-02")),
    metric   = c("open", "close", "open"),
    value    = c(100, 102, 200)
  )

  mockery::stub(insert_new_data, "DBI::dbGetQuery",    existing)
  mockery::stub(insert_new_data, "DBI::dbAppendTable", 1L)

  result <- insert_new_data(new_data, mock_con)

  # Only the row for idx_002 on 2024-01-02 should be inserted
  expect_equal(nrow(result), 1)
  expect_equal(result$index_ts, "idx_002")
})

test_that("insert_new_data returns an empty tibble when all rows already exist", {
  mock_con <- structure(list(), class = "PqConnection")

  existing <- tibble::tibble(
    index_ts = "idx_001",
    date     = as.Date("2024-01-01"),
    metric   = "open",
    value    = 100
  )

  new_data <- tibble::tibble(
    index_ts = "idx_001",
    date     = as.Date("2024-01-01"),
    metric   = "open",
    value    = 100
  )

  mockery::stub(insert_new_data, "DBI::dbGetQuery",    existing)
  mockery::stub(insert_new_data, "DBI::dbAppendTable", 0L)

  result <- insert_new_data(new_data, mock_con)

  expect_equal(nrow(result), 0)
})

test_that("insert_new_data returns all rows when the database is empty", {
  mock_con <- structure(list(), class = "PqConnection")

  new_data <- tibble::tibble(
    index_ts = c("idx_001", "idx_002"),
    date     = as.Date(c("2024-01-01", "2024-01-02")),
    metric   = c("open", "open"),
    value    = c(100, 200)
  )

  # Simulate an empty existing table
  empty_db <- tibble::tibble(
    index_ts = character(0),
    date     = as.Date(character(0)),
    metric   = character(0),
    value    = numeric(0)
  )

  mockery::stub(insert_new_data, "DBI::dbGetQuery",    empty_db)
  mockery::stub(insert_new_data, "DBI::dbAppendTable", 2L)

  result <- insert_new_data(new_data, mock_con)

  expect_equal(nrow(result), 2)
})

test_that("insert_new_data calls DBI::dbAppendTable with the 'data_sp500' table name", {
  mock_con <- structure(list(), class = "PqConnection")

  captured_table <- NULL

  new_data <- tibble::tibble(
    index_ts = "idx_001",
    date     = as.Date("2024-01-01"),
    metric   = "open",
    value    = 100
  )

  mockery::stub(insert_new_data, "DBI::dbGetQuery", tibble::tibble(
    index_ts = character(0), date = as.Date(character(0)),
    metric = character(0),   value = numeric(0)
  ))
  mockery::stub(insert_new_data, "DBI::dbAppendTable", function(con, name, value, ...) {
    captured_table <<- name
    1L
  })

  insert_new_data(new_data, mock_con)
  expect_equal(captured_table, "data_sp500")
})
