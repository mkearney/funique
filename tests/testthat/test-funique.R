context("test-funique")

test_that("multiplication works", {
  ## set seed
  seed(20180812)

  ## generate data
  d <- data.frame(
    x = rnorm(1000),
    y = seq.POSIXt(as.POSIXct("2018-01-01"),
      as.POSIXct("2018-12-31"), length.out = 10))

  ## create data frame with duplicate rows
  d <- d[c(1:1000, sample(1:1000, 500, replace = TRUE)), ]
  row.names(d) <- NULL

  ## should be 1000
  expect_true(nrow(funique(d)) == 1000)

  ## should be equal
  expect_equal(unique(d), funique(d))

  ## try non-data frame
  abc <- sample(letters, 100)

  ## should be equal
  expect_equal(unique(abc), funique(abc))
})
