library(tidyquant)
library(dplyr)
yahoo_query_data <- function(batch) {

  data <- tq_get(batch,
                        get  = "stock.prices",
                        from = "2000-01-01",
                        to   = Sys.Date()-1)

  batchComplete <- data %>%
      group_by(symbol) %>%
      slice_max(date, n = 1, with_ties = FALSE) %>%
      ungroup()

  return(batchComplete)
}
