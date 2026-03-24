test_that("log_summary sets status to 'OK' when finalDB has rows", {
  log <- pipelineR:::build_summary_table()

  finalDB <- tibble::tibble(
    index_ts = c("idx_001", "idx_001"),
    date     = as.Date(c("2024-01-01", "2024-01-02")),
    metric   = c("open", "close"),
    value    = c(100, 102)
  )

  result <- pipelineR:::log_summary(log, finalDB, user = "test_user")

  expect_true(all(result$status == "OK"))
})

test_that("log_summary sets status to 'ERROR' when finalDB is empty", {
  log     <- pipelineR:::build_summary_table()
  finalDB <- tibble::tibble(
    index_ts = character(0),
    date     = as.Date(character(0)),
    metric   = character(0),
    value    = numeric(0)
  )

  result <- pipelineR:::log_summary(log, finalDB, user = "test_user")

  expect_equal(nrow(result), 1)
  expect_equal(result$status, "ERROR")
  expect_equal(result$message, "No lines inserted.")
})

test_that("log_summary records the correct user_login", {
  log <- pipelineR:::build_summary_table()

  finalDB <- tibble::tibble(
    index_ts = "idx_001",
    date     = as.Date("2024-01-01"),
    metric   = "open",
    value    = 100
  )

  result <- pipelineR:::log_summary(log, finalDB, user = "ciaran")

  expect_true(all(result$user_login == "ciaran"))
})

test_that("log_summary message contains row count when rows are inserted", {
  log <- pipelineR:::build_summary_table()

  finalDB <- tibble::tibble(
    index_ts = rep("idx_001", 3),
    date     = as.Date(c("2024-01-01", "2024-01-02", "2024-01-03")),
    metric   = c("open", "close", "high"),
    value    = c(100, 102, 105)
  )

  result <- pipelineR:::log_summary(log, finalDB, user = "test_user")

  expect_true(all(grepl("3", result$message)))
})

test_that("log_summary returns a tibble with the same column structure", {
  log     <- pipelineR:::build_summary_table()
  finalDB <- tibble::tibble(
    index_ts = "idx_001",
    date     = as.Date("2024-01-01"),
    metric   = "open",
    value    = 100
  )

  result <- pipelineR:::log_summary(log, finalDB, user = "test_user")

  expect_named(result, c("user_login", "batch_id", "symbol", "status",
                         "n_rows", "message", "timestamp"))
})

test_that("log_summary removes duplicate rows", {
  log <- pipelineR:::build_summary_table()

  # Produce the same entry twice by calling log_summary twice on the same data
  finalDB <- tibble::tibble(
    index_ts = "idx_001",
    date     = as.Date("2024-01-01"),
    metric   = "open",
    value    = 100
  )

  log1 <- pipelineR:::log_summary(log, finalDB, user = "test_user")
  # Adding the same row again via a second log_summary call
  log2 <- pipelineR:::log_summary(log1, finalDB, user = "test_user")

  # The duplicate (identical row) should be removed by unique()
  expect_equal(nrow(log2), nrow(log1))
})
