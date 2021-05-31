library(testthat)
library(abscorr)
library(dplyr)


test_that("asced_foe is as-expected", {
  # Check object
  expect_is(asced_foe, "tbl_df")
  # Check non-title labels
  expect_equal(asced_foe[[2]][200], "Health")
  # Check title labels
  expect_equal(asced_foe[[2]][150], "Architecture and Building")
  # Check digit conversion
  expect_identical(asced_foe$foe2_code,
                   substr(asced_foe$foe6_code, 1, 2))
  expect_identical(asced_foe$foe4_code,
                   substr(asced_foe$foe6_code, 1, 4))
  # Spotcheck occupations and skill levels
  expect_equal(asced_foe %>%
                 filter(foe6_code == "091901") %>%
                 pull(foe6),
               "Economics")

  expect_equal(asced_foe %>%
                 filter(foe6_code == "129999") %>%
                 pull(foe6),
               "Mixed Field Programmes, n.e.c.")

  expect_equal(asced_foe %>%
                 filter(foe6_code == "040101") %>%
                 pull(foe4),
               "Architecture and Urban Environment")
})


test_that("clean_asced_foe works as intended", {
  # Check that it matches with and &
  expect_equal(clean_asced_foe("Architecture & urban environment"), "Architecture and Urban Environment")
  # Check that it doesn't match when looking for exact match
  expect_equal(clean_asced_foe("Maths", silent = TRUE), NA_character_)
  # Check that it does match when looking for fuzzy match
  expect_equal(clean_asced_foe("Maths", fuzzy_match = TRUE), "Mathematical Sciences")
  # Test class is as expected
  expect_is(clean_asced_foe("Architecture & urban environment"), "character")
  # Test length
  expect_length(clean_asced_foe(c("Architecture & urban environment", "mathematical sciences")), 2)
})



