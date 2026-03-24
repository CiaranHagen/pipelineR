#' Split df
#' Splits the df into batches of 25 items.
#'
#' @param symbols
#'
#' @returns list(df("batches"), integer("nrows"))
#' @export
#'
#' @examples
split_batch <- function(symbols) {
  chunk <- 25
  n <- nrow(symbols)
  nrows <- ceiling(n/chunk)
  r  <- rep(1:nrows,each=chunk)[1:n]
  batches <- split(symbols,r)
  output <- list("batches" = batches, "nrows" = r)
  return(output)
}
