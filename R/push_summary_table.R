push_summary_table <- function(db, con) {
  DBI::dbAppendTable(con, "pipeline_logs", db)
}
