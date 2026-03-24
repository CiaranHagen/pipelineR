data <- tidyquant::tq_get("AAPL",
                        get  = "stock.prices",
                        from = "2000-01-01")
test <- data %>% arrange(desc(date))
