#' Insert New Stock Data into Database (Deduplicating)
#'
#' Removes duplicate records and inserts new stock data into the database.
#'
#' This function compares new data against existing database records and only
#' inserts rows that represent new data. Duplicates are identified based on
#' matching \code{date} and \code{index_ts} values, preventing data duplication
#' and maintaining database integrity.
#'
#' @param newDB A tibble containing formatted stock data (typically output from
#'   \code{\link{format_data}}) with columns: \code{index_ts}, \code{date},
#'   \code{metric}, and \code{value}.
#'
#' @param con A DBI connection object created by \code{\link{connect_db}}.
#'   This connection must have write privileges on the \code{data_sp500} table.
#'
#' @return A tibble containing only the rows that were successfully inserted
#'   (i.e., new records not already in the database). Returns an empty tibble
#'   if all records in \code{newDB} already exist.
#'
#' @details
#' The function performs these steps:
#' \enumerate{
#'   \item Fetches all existing records from \code{student_ciaran.data_sp500}
#'   \item Uses \code{dplyr::anti_join} to identify new records (matched on
#'     \code{date} and \code{index_ts})
#'   \item Appends only the new records to the database table
#'   \item Returns the inserted data for verification
#' }
#'
#' This approach ensures the function is idempotent and safe to run multiple times.
#'
#' @seealso
#' \code{\link{format_data}} for preparing data before insertion,
#' \code{\link{connect_db}} for creating the database connection
#'
#' @importFrom DBI dbGetQuery dbAppendTable
#' @importFrom dplyr anti_join
#'
#' @export
#'
#' @examples
#' \dontrun{
#' con <- connect_db()
#'
#' # Insert new data, automatically skipping duplicates
#' inserted_data <- insert_new_data(formatted_db, con)
#'
#' # Check how many new records were inserted
#' nrow(inserted_data)
#'
#' DBI::dbDisconnect(con)
#' }
insert_new_data <- function(newDB, con) {
  oldDB <- DBI::dbGetQuery(con, "SELECT * FROM student_ciaran.data_sp500;")
  finalDB <- dplyr::anti_join(newDB, oldDB, by = c('date', 'index_ts', 'metric'))

  DBI::dbAppendTable(con, "data_sp500", finalDB)
  return(finalDB)
}

#  SELECT index_ts,date,metric,value,id FROM student_ciaran.data_sp500 ORDER BY date DESC;

# CREATE TABLE student_ciaran.datadev AS SELECT * FROM el_professor.data_sp500;
