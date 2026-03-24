test_that("push_summary_table calls DBI::dbAppendTable with 'pipeline_logs'", {
  mock_con       <- structure(list(), class = "PqConnection")
  captured_table <- NULL
  captured_data  <- NULL

  log <- pipelineR:::build_summary_table()

  mockery::stub(pipelineR:::push_summary_table, "DBI::dbAppendTable", function(con, name, value, ...) {
    captured_table <<- name
    captured_data  <<- value
    1L
  })

  pipelineR::push_summary_table(log, mock_con)

  expect_equal(captured_table, "pipeline_logs")
})

test_that("push_summary_table passes the provided tibble to DBI::dbAppendTable", {
  mock_con      <- structure(list(), class = "PqConnection")
  captured_data <- NULL

  log <- pipelineR:::build_summary_table()

  mockery::stub(pipelineR:::push_summary_table, "DBI::dbAppendTable", function(con, name, value, ...) {
    captured_data <<- value
    1L
  })

  pipelineR:::push_summary_table(log, mock_con)

  expect_identical(captured_data, log)
})
