library(testthat)
library(strayr)
library(dplyr)


test_that("anzsco2009 is as-expected", {
  # Check object
  expect_is(anzsco2009, "tbl_df")
  # Check non-title labels
  expect_equal(anzsco2009[[2]][1111], "Labourers")
  # Check title labels
  expect_equal(anzsco2009[[2]][721], "Community and Personal Service Workers")
  # Check digit conversion
  expect_identical(anzsco2009$anzsco_major_code,
                   substr(anzsco2009$anzsco_occupation_code, 1, 1))
  expect_identical(anzsco2009$anzsco_submajor_code,
                   substr(anzsco2009$anzsco_minor_code, 1, 2))
  # Spotcheck occupations and skill levels
  expect_equal(anzsco2009 %>%
                 filter(anzsco_occupation_code == "452311") %>%
                 pull(anzsco_occupation),
               "Diving Instructor (Open Water)")

  expect_equal(anzsco2009 %>%
                 filter(anzsco_occupation_code == "899999") %>%
                 pull(anzsco_occupation),
               "Labourers nec")

  expect_equal(anzsco2009 %>%
                 filter(anzsco_occupation_code == "631112") %>%
                 pull(skill_level) %>%
                 as.character(),
               "5")
})
