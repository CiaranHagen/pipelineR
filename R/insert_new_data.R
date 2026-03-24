#' Insert new data into DB
#' Removes duplicates from df before push and then pushes it to the DB.
#'
#' @param newDB
#' @param con
#'
#' @returns df(finalDB)
#' @export
#'
#' @examples
insert_new_data <- function(newDB, con) {
  oldDB <- DBI::dbGetQuery(con, "SELECT * FROM student_ciaran.data_sp500;")
  db <- dplyr::anti_join(newDB, oldDB, by = c('date', 'index_ts'))

  DBI::dbAppendTable(con, "data_sp500", db)
  return(db)
}
