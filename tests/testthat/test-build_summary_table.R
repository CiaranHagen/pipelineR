test_that("build_summary_table returns a tibble with zero rows", {
  log <- pipelineR:::build_summary_table()
  expect_equal(nrow(log), 0)
})

test_that("build_summary_table returns exactly 7 columns", {
  log <- pipelineR:::build_summary_table()
  expect_equal(ncol(log), 7)
})

test_that("build_summary_table column names are correct", {
  log <- pipelineR:::build_summary_table()
  expect_equal(
    colnames(log),
    c("user_login", "batch_id", "symbol", "status", "n_rows", "message", "timestamp")
  )
})

test_that("build_summary_table column types are correct", {
  log <- pipelineR:::build_summary_table()
  expect_type(log$user_login, "character")
  expect_type(log$batch_id,   "double")
  expect_type(log$symbol,     "character")
  expect_type(log$status,     "character")
  expect_type(log$n_rows,     "double")
  expect_type(log$message,    "character")
  expect_s3_class(log$timestamp, "Date")
})

test_that("build_summary_table returns a tibble (not just a data.frame)", {
  log <- pipelineR:::build_summary_table()
  expect_s3_class(log, "tbl_df")
})
