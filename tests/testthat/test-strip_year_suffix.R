library(testthat)
library(strayr)
library(dplyr)

test_that("strip_year_suffix works as expected", {

  orig <- tibble(
    sa1_code_2021 = NA,
    sa2_code_2021 = NA,
    sa2_name_2021 = NA,
    sa3_code_2021 = NA,
    sa3_name_2021 = NA,
    sa4_code_2021 = NA,
    sa4_name_2021 = NA,
    gcc_code_2021 = NA,
    gcc_name_2021 = NA,
    state_code_2021 = NA,
    state_name_2021 = NA,
    areasqkm_2021 = NA,

    sa1_code_2016 = NA,
    sa2_code_2016 = NA,
    sa2_name_2016 = NA,
    sa3_code_2016 = NA,
    sa3_name_2016 = NA,
    sa4_code_2016 = NA,
    sa4_name_2016 = NA,
    gcc_code_2016 = NA,
    gcc_name_2016 = NA,
    state_code_2016 = NA,
    state_name_2016 = NA,
    areasqkm_2016 = NA,

    cent_lat = NA,
    cent_long = NA,
    geometry = NA
  )

  target_names <- c(
    "sa1_code",
    "sa2_code",
    "sa2_name",
    "sa3_code",
    "sa3_name",
    "sa4_code",
    "sa4_name",
    "gcc_code",
    "gcc_name",
    "state_code",
    "state_name",
    "areasqkm",

    "sa1_code",
    "sa2_code",
    "sa2_name",
    "sa3_code",
    "sa3_name",
    "sa4_code",
    "sa4_name",
    "gcc_code",
    "gcc_name",
    "state_code",
    "state_name",
    "areasqkm",

    "cent_lat",
    "cent_long",
    "geometry"
  )

  expect_identical(
    names(strip_year_suffix(orig)),
    target_names)

})

test_that("strip_year_suffix works within read_absmap", {
  d <- read_absmap("sa42021", remove_year_suffix = TRUE)
  expect_false(any(str_detect(names(d), "2021")))
})
