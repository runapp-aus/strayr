test_that("read_absmaps() works", {

  expect_type(read_absmap("sa42016"), "list")
  expect_type(read_absmap("SA42016"), "list")

  expect_identical(names(read_absmap("state2021")),
                   c("state_code_2021",
                     "state_name_2021",
                     "areasqkm_2021",
                     "cent_lat",
                     "cent_long",
                     "geometry"))

  expect_identical(names(read_absmap("SA32016")),
                   c("sa3_code_2016", "sa3_name_2016", "sa4_code_2016",
                     "sa4_name_2016", "gcc_code_2016", "gcc_name_2016",
                     "state_code_2016", "state_name_2016", "areasqkm_2016", "cent_long",
                     "cent_lat", "geometry"))

  # errors
  expect_error(read_absmap(), regexp = "Please")
  expect_error(read_absmap(area = "sa2"), regexp = "Please")
  expect_error(read_absmap(year = 2011), regexp = "Please")

})
