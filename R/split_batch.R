split_batch <- function(symbols) {
  chunk <- 25
  n <- nrow(symbols)
  nrows <- ceiling(n/chunk)
  r  <- rep(1:nrows,each=chunk)[1:n]
  batches <- split(symbols,r)
  output <- list("batches" = batches, "nrows" = nrows)
  return(output)
}
