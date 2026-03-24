# Extracted from test-connect_db.R:14

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "pipelineR", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
withr::with_envvar(
    c(PG_DB = "testdb", PG_HOST = "localhost", PG_USER = "admin", PG_PASSWORD = "secret"),
    {
      mock_con <- structure(list(), class = "PqConnection")

      mockery::stub(connect_db, "DBI::dbConnect", function(drv, dbname, host, user, password, port) {
        expect_equal(dbname,   "testdb")
        expect_equal(host,     "localhost")
        expect_equal(user,     "admin")
        expect_equal(password, "secret")
        expect_equal(port,     5432)
        mock_con
      })

      result <- connect_db()
      expect_identical(result, mock_con)
    }
  )
