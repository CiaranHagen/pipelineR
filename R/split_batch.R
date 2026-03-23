split_batch <- function(symbols) {
  chunk <- 25
  n <- nrow(symbols)
  r  <- rep(1:ceiling(n/chunk),each=chunk)[1:n]
  batches <- split(symbols,r)
  output <- list(batches, r)
  return(output)
}
