# Extracted from test-connect_db.R:31

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
withr::with_envvar(
    c(PG_DB = "db", PG_HOST = "host", PG_USER = "user", PG_PASSWORD = "pw"),
    {
      captured_port <- NULL

      mockery::stub(connect_db, "DBI::dbConnect", function(drv, dbname, host, user, password, port) {
        captured_port <<- port
        structure(list(), class = "PqConnection")
      })

      connect_db()
      expect_equal(captured_port, 5432)
    }
  )
