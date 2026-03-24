#' Split Symbols into Processing Batches
#'
#' Divides stock symbols into fixed-size batches for efficient processing.
#'
#' This function splits the input tibble of symbols into multiple batches,
#' each containing a maximum of 25 items. Batching is useful for processing
#' large symbol lists in manageable chunks, improving performance when
#' fetching stock data from Yahoo Finance.
#'
#' @param symbols A tibble containing stock symbols, typically with a
#'   \code{symbol} column. The function operates on the number of rows.
#'
#' @return A list containing:
#'   \itemize{
#'     \item \code{batches}: A list of tibbles, each containing ≤25 symbols
#'     \item \code{nrows}: An integer vector indicating batch assignment for each row
#'   }
#'
#' @details
#' Batch size is fixed at 25. For example, with 57 symbols:
#' \enumerate{
#'   \item Batch 1: rows 1-25 (25 symbols)
#'   \item Batch 2: rows 26-50 (25 symbols)
#'   \item Batch 3: rows 51-57 (7 symbols)
#' }
#'
#' Access individual batches with: \code{output$batches[[i]]}
#'
#' Determine total number of batches with: \code{length(unique(output$nrows))}
#'
#' @seealso
#' \code{\link{fetch_symbols}} for obtaining the symbol list,
#' \code{\link{yahoo_query_data}} for processing each batch
#'
#' @export
#'
#' @examples
#' \dontrun{
#' symbols <- fetch_symbols(con)
#' batched <- split_batch(symbols)
#' num_batches <- length(unique(batched$nrows))
#' first_batch <- batched$batches[[1]]
#' }
split_batch <- function(symbols) {
  chunk <- 25
  n <- nrow(symbols)
  nrows <- ceiling(n/chunk)
  r  <- rep(1:nrows,each=chunk)[1:n]
  batches <- split(symbols,r)
  output <- list("batches" = batches, "nrows" = r)
  return(output)
}
