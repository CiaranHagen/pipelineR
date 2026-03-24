test_that("connect_db calls DBI::dbConnect with credentials from environment variables", {
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
})

test_that("connect_db uses port 5432", {
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
})
