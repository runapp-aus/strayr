test_that("read_absmaps() works", {

  expect_type(read_absmap("sa42016"), "list")

  expect_identical(names(read_absmap("state2021")),
                   c("state_code_2021",
                     "state_name_2021",
                     "areasqkm_2021",
                     "cent_lat",
                     "cent_long",
                     "geometry"))

  # errors
  expect_error(read_absmap(), regexp = "Please")
  expect_error(read_absmap(area = "sa2"), regexp = "Please")
  expect_error(read_absmap(year = 2011), regexp = "Please")

})
