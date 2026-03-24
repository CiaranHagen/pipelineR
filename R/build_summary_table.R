#' Format Stock Data to Long Format for Database
#' @return A tibble with columns:
#' @importFrom dplyr slice add_row
#' @importFrom tibble tibble
#'
#' @export
#'
#' @examples



build_summary_table <- function() {
  logTibble <- tibble(
    user_login = '',
    batch_id = 0,
    symbol = '',
    status = '',
    n_rows = 0,
    message = '',
    timestamp = as.Date(x = integer(0), origin = "2000-01-01")
  )[0,]

  return(logTibble)
}
