test_that("aus_seasons work as expected", {
  sample_dates <- c("2022-01-01","2018-10-04","2016-07-20")

  expect_equal(aus_seasons(sample_dates,"temperate"),c("Summer","Spring","Winter"))
  expect_equal(aus_seasons(sample_dates,"tropical"),c("Wet Season","Dry Season","Dry Season"))
})
